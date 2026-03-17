import urllib.request
import json
import codecs

def generate_sql():
    # Fetch data from datos.gov.co https://www.datos.gov.co/resource/gdxc-w37w.json?$limit=2000
    url = "https://www.datos.gov.co/resource/gdxc-w37w.json?$limit=2000"
    req = urllib.request.Request(url)
    with urllib.request.urlopen(req) as response:
        data = json.loads(response.read().decode('utf-8'))

    departments = {} # code -> {name, code}
    cities = [] # {dpto_code, code, name, lat, lng}

    for row in data:
        # Some rows might be just departments or lack coords
        dpto_code = row.get("cod_dpto")
        dpto_name = row.get("dpto", "").title()
        city_code = row.get("cod_mpio")
        city_name = row.get("nom_mpio", "").title()
        
        # Parse lat/lng with comma replacement
        lat_str = row.get("latitud", "").replace(",", ".")
        lng_str = row.get("longitud", "").replace(",", ".")
        
        try:
            lat = float(lat_str)
            lng = float(lng_str)
        except ValueError:
            lat, lng = 0.0, 0.0

        if dpto_code and dpto_name:
            if dpto_code not in departments:
                # exceptions for nice names
                if dpto_name.upper() == "BOGOTÁ, D.C.": dpto_name = "Bogotá, D.C."
                departments[dpto_code] = {"code": dpto_code, "name": dpto_name}
        
        if dpto_code and city_code and city_name:
            if city_name.upper() == "BOGOTÁ, D.C.": city_name = "Bogotá, D.C."
            cities.append({
                "dpto_code": dpto_code,
                "city_code": city_code,
                "city_name": city_name,
                "lat": lat,
                "lng": lng
            })

    sql_lines = []
    sql_lines.append("-- ============================================================")
    sql_lines.append("-- V9: Populate Complete Colombia Cities from DANE DIVIPOLA")
    sql_lines.append("-- ============================================================")
    sql_lines.append("")
    
    # 1. Provide a cleanup to avoid duplicates for CO
    sql_lines.append("-- 1. Clean existing DEPARTMENTS and CITIES for Colombia to avoid duplicates")
    sql_lines.append("DELETE FROM catalog_item ")
    sql_lines.append("WHERE catalog_code = 'CITY' AND parent_id IN (")
    sql_lines.append("    SELECT id FROM (")
    sql_lines.append("        SELECT id FROM catalog_item ")
    sql_lines.append("        WHERE catalog_code = 'DEPARTMENT' AND parent_id = (")
    sql_lines.append("            SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO'")
    sql_lines.append("        )")
    sql_lines.append("    ) as temp")
    sql_lines.append(");")
    sql_lines.append("")
    sql_lines.append("DELETE FROM catalog_item ")
    sql_lines.append("WHERE catalog_code = 'DEPARTMENT' AND parent_id = (")
    sql_lines.append("    SELECT id FROM (")
    sql_lines.append("        SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO'")
    sql_lines.append("    ) as temp")
    sql_lines.append(");")
    sql_lines.append("")

    # 2. Insert DEPARTMENTS
    sql_lines.append("-- 2. Insert all 32 Departments")
    for i, (d_code, d_info) in enumerate(departments.items()):
        name = d_info["name"].replace("'", "''")
        extra = f'{{"daneCode": "{d_code}"}}'
        sql_lines.append(f"INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)")
        sql_lines.append(f"SELECT 'DEPARTMENT', id, '{d_code}', '{name}', {i+1}, '{extra}', 'system'")
        sql_lines.append(f"FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';")
    
    sql_lines.append("")
    
    # 3. Insert CITIES
    sql_lines.append(f"-- 3. Insert all {len(cities)} Cities")
    # Batch inserts per department to optimize processing speed
    
    for i, city in enumerate(cities):
        c_code = city["city_code"]
        c_name = city["city_name"].replace("'", "''")
        d_code = city["dpto_code"]
        lat = city["lat"]
        lng = city["lng"]
        
        extra = f'{{"daneCode": "{c_code}", "latitude": {lat:.6f}, "longitude": {lng:.6f}}}'
        
        # We need to find the department ID
        sql_lines.append(f"INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)")
        sql_lines.append(f"SELECT 'CITY', id, '{c_code}', '{c_name}', {i+1}, '{extra}', 'system'")
        sql_lines.append(f"FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '{d_code}'")
        # Ensure we only match departments for Colombia
        sql_lines.append(f"  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');")

    with codecs.open("V9__populate_colombia_cities.sql", "w", "utf-8") as f:
        f.write("\n".join(sql_lines) + "\n")
        
    print(f"Generated V9__populate_colombia_cities.sql with {len(departments)} departments and {len(cities)} cities.")

if __name__ == "__main__":
    generate_sql()
