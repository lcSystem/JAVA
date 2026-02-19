package com.allianceever.projectERP.AuthenticatedBackend.domain.ports.in;

import com.allianceever.projectERP.AuthenticatedBackend.domain.model.Menu;
import java.util.List;

public interface GetMenuUseCase {
    List<Menu> getMenuTreeForUser(Integer userId);
    List<Menu> getAllMenus();
}
