const http = require('http');

async function test() {
  try {
    const loginRes = await fetch('http://localhost:8080/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username: "admin", password: "password" }) 
    });
    
    if(!loginRes.ok) {
        console.log("Login failed:", loginRes.status, await loginRes.text());
        return;
    }
    const tokenData = await loginRes.json();
    console.log("Login success");
    const token = tokenData.jwt || tokenData.token;
    
    // 2. Submit Request
    const submitRes = await fetch('http://localhost:8080/api/credit-requests/submit', {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
      body: JSON.stringify({
        creditTypeId: 1, 
        applicantUserId: 1,
        amount: 500000,
        termMonths: 12,
        purpose: "Test",
        debtorAdditionalInfo: JSON.stringify({documentType: "CC"}),
        debtorReferences: [],
        coDebtors: []
      })
    });
    
    const body = await submitRes.text();
    console.log("SUBMIT STATUS:", submitRes.status);
    console.log("SUBMIT BODY:", body);
  } catch(e) {
    console.error(e);
  }
}
test();
