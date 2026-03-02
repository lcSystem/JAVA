package com.projectERP.AuthenticatedBackend.domain.ports.in;

import com.projectERP.AuthenticatedBackend.domain.model.Menu;
import java.util.List;

public interface GetMenuUseCase {
    List<Menu> getMenuTreeForUser(Integer userId);
    List<Menu> getAllMenus();
}
