/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper
} from '@ohos/basicutils';
import { StartAbilityUtil } from '@ohos/windowscene';
import { localEventManager, GlobalContext } from '@ohos/frameworkwrapper';
import { MenuInfo } from '../bean/MenuInfo';
import { CommonConstants } from '../constants/CommonConstants';
import { EventConstants } from '../constants/EventConstants';
import { StyleConstants } from '../constants/StyleConstants';
import { ContextMenuListener } from '../listener/ContextMenuListener';
import { FormModel } from '../model/FormModel';
import { ViewManager } from './ViewManager';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { AppItemInfo } from '../bean/AppItemInfo';
import { CardItemInfo } from '../bean/CardItemInfo';
import { GridLayoutItemInfo } from '../TsIndex';

const TAG = 'MenuInfoManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * MenuInfoManager.
 */
export class MenuInfoManager {
  private static mInstance: MenuInfoManager;
  private mViewManager: ViewManager;
  private readonly mFormModel: FormModel;
  private readonly mMenuListenerMap = new Map<string, ContextMenuListener>();
  private desktopContext: ServiceExtensionContext = GlobalContext.getContext();

  private constructor() {
    this.mViewManager = ViewManager.getInstance();
    this.mFormModel = FormModel.getInstance();
  }

  /**
   * Get the MenuInfoManager object.
   *
   * @return {object} MenuInfoManager singleton
   */
  static getInstance(): MenuInfoManager {
    if (!MenuInfoManager.mInstance) {
      MenuInfoManager.mInstance = new MenuInfoManager();
    }
    return MenuInfoManager.mInstance;
  }

  /**
   * 创建菜单信息
   *
   * @param menuType 菜单类型
   * @param menuImgSrc 菜单图标
   * @param menuText 菜单文本
   */
  createMenuInfo(menuType: number, menuImgSrc: string, menuText: Resource): MenuInfo {
    let menuInfo: MenuInfo = new MenuInfo();
    menuInfo.menuType = menuType;
    menuInfo.menuImgSrc = menuImgSrc;
    menuInfo.menuText = menuText;
    return menuInfo;
  }

  /**
   * 服务卡片
   *
   * @param formInfo 卡片信息
   * @param formDialog 回调函数
   * @param isPadFlag 是否是pc
   * @param appName 卡片名称
   * @param formManagerShowFrom 卡片管理界面的来源
   */
  createServiceFormMenuInfo(formInfo: AppItemInfo, formDialog: CustomDialogController, isPadFlag: boolean,
    appName: string, formManagerShowFrom: number): MenuInfo {
    let serviceFormMenu: MenuInfo = this.createMenuInfo(CommonConstants.MENU_TYPE_FIXED,
      '/common/pics/ic_public_app.svg', $r('app.string.add_form_to_desktop'));
    serviceFormMenu.onMenuClick = (): void => {
      log.showInfo('Launcher click menu into form manager view.');
      if (appName !== null) {
        formInfo.appName = appName;
      }
      AppStorage.setOrCreate('formAppInfo', formInfo);
      if (!isPadFlag) {
        this.mFormModel.doBeforeJumpToFormManager(String(formInfo.bundleName)).then(() =>{
          this.mViewManager.jumpToFormManagerView(formInfo, formManagerShowFrom);
        });
      } else {
        AppStorage.setOrCreate('showUninstallDialog', true);
        formDialog.open();
      }
    };
    return serviceFormMenu;
  }

  /**
   * 卡片中心
   *
   * @param formDialog 回调函数
   * @param isPadFlag 是否是pc
   * @param formManagerShowFrom 卡片管理界面的来源
   */
  createFormCenterMenuInfo(bundleName: string, formInfo: AppItemInfo, formManagerShowFrom: number): MenuInfo {
    let formCenterMenu: MenuInfo = this.createMenuInfo(CommonConstants.MENU_TYPE_FIXED,
      '/common/pics/ic_public_app.svg', $r('app.string.form_center'));
    formCenterMenu.onMenuClick = (): void => {
      log.showInfo('Launcher click menu into form center view.');
      this.mViewManager.jumpFormServiceView(formManagerShowFrom);
    };
    return formCenterMenu;
  }

  /**
   * 更多服务卡片
   *
   * @param formInfo 卡片信息
   * @param formDialog 回调函数
   * @param isPadFlag 是否是pc
   * @param appName 卡片名称
   * @param formManagerShowFrom 卡片管理界面的来源
   */
  createMoreServiceFormMenuInfo(formInfo: AppItemInfo | GridLayoutItemInfo,
    formDialog: CustomDialogController, isPadFlag: boolean,
    appName: string, formManagerShowFrom: number, clickHandle: Function): MenuInfo {
    const addFormToDeskTopMenu: MenuInfo = this.createMenuInfo(CommonConstants.MENU_TYPE_FIXED,
      '/common/pics/ic_form_center.svg', $r('app.string.add_form_to_desktop_more'));
    addFormToDeskTopMenu.onMenuClick = (): void => {
      log.showInfo(`Launcher ${appName} click menu item into add form to desktop view`);
      if (appName !== null) {
        formInfo.appName = appName;
      }
      clickHandle?.();
      AppStorage.setOrCreate('formAppInfo', formInfo);
      this.mFormModel.doBeforeJumpToFormManager(String(formInfo.bundleName)).then(() =>{
        this.mViewManager.jumpToFormManagerView(formInfo, formManagerShowFrom);
      });
    };
    return addFormToDeskTopMenu;
  }

  /**
   * 编辑卡片
   *
   * @param formInfo 卡片信息
   */
  createEditFormMenuInfo(formInfo: CardItemInfo): MenuInfo {
    const editForm: MenuInfo = this.createMenuInfo(CommonConstants.MENU_TYPE_FIXED,
      '/common/pics/ic_public_edit.svg', $r('app.string.form_edit'));
    editForm.onMenuClick = (): void => {
      log.showInfo(`Launcher click menu item into form edit view:${formInfo.formConfigAbility}`);
      const abilityName: string =
        formInfo.formConfigAbility?.slice(CommonConstants.FORM_CONFIG_ABILITY_PREFIX.length) ?? '';
      StartAbilityUtil.startAbilityFormEdit(abilityName, formInfo.bundleName, formInfo.moduleName, formInfo.cardId);
    };
    return editForm;
  }

  /**
   * 添加卡片至桌面
   */
  createAddFormToDesktopMenuInfo(): MenuInfo {
    const addFormToDesktopMenuInfo: MenuInfo = this.createMenuInfo(CommonConstants.MENU_TYPE_FIXED,
      '/common/pics/ic_form_addToDesktop.svg', $r('app.string.add_to_desktop'));
    return addFormToDesktopMenuInfo;
  }

  /**
   * 添加到快捷栏
   *
   * @param appInfo app信息
   * @param appName app名
   */
  createAddToDockMenuInfo(appInfo: AppItemInfo, appName: string): MenuInfo {
    const addToDockMenu: MenuInfo = this.createMenuInfo(CommonConstants.MENU_TYPE_FIXED,
      '/common/pics/ic_public_copy.svg', $r('app.string.app_center_menu_add_dock'));
    addToDockMenu.onMenuClick = (): void => {
      log.showInfo('Launcher click menu item add to smartDock entry');
      if (appName !== null || appName !== '') {
        appInfo.appName = appName;
      }
      if (typeof(appInfo.typeId) === 'undefined') {
        // 应用中心typeId的默认为app
        appInfo.typeId = CommonConstants.TYPE_APP;
      }
      log.showInfo('Launcher click menu item add to dock');
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_DOCK_ITEM_ADD, appInfo);
    };
    return addToDockMenu;
  }

  /**
   * 从dock栏添加到桌面
   *
   * @param appInfo app信息
   */
  createAddToWorkSpaceMenuInfo(appInfo: AppItemInfo): MenuInfo {
    const addToWorkSpaceMenu: MenuInfo = this.createMenuInfo(CommonConstants.MENU_TYPE_FIXED,
      '/common/pics/ic_public_copy.svg', $r('app.string.app_center_menu_add_desktop'));
    addToWorkSpaceMenu.onMenuClick = (): void => {
      log.showDebug('onMenuClick item add to pageDesk:' + appInfo.bundleName);
    };
    return addToWorkSpaceMenu;
  }

  /**
   * 移出文件夹
   *
   * @param appInfo app信息
   * @param folderCallback 回调
   */
  createMoveOutFolderMenuInfo(appInfo: AppItemInfo, folderCallback: Function): MenuInfo {
    const moveOutMenu: MenuInfo = this.createMenuInfo(CommonConstants.MENU_TYPE_FIXED,
      '/common/pics/ic_public_remove.svg', $r('app.string.remove_app_from_folder'));
    moveOutMenu.onMenuClick = (): void => {
      log.showInfo('Launcher click menu item remove app from folder');
      folderCallback(appInfo);
    };
    return moveOutMenu;
  }

  /**
   * 移除/卸载 app
   *
   * @param appInfo app信息
   * @param isPadFlag 是否是pc
   */
  creadUninstallMenuInfo(appInfo: AppItemInfo, isPadFlag: boolean): MenuInfo {
    let menuImgSrc = isPadFlag ? '/common/pics/ic_public_remove.svg' : '/common/pics/ic_public_delete.svg';
    let menuText = isPadFlag ? $r('app.string.delete_app') : $r('app.string.uninstall');
    const uninstallMenu: MenuInfo = this.createMenuInfo(CommonConstants.MENU_TYPE_FIXED,
      menuImgSrc, menuText);
    uninstallMenu.menuEnabled = appInfo.isUninstallAble ?? true;
    return uninstallMenu;
  }

  /**
   * 打开
   */
  createOpenMenuInfo(): MenuInfo {
    return this.createMenuInfo(CommonConstants.MENU_TYPE_FIXED,
      '/common/pics/ic_public_add_norm.svg', $r('app.string.app_menu_open'));
  }

  /**
   * 重命名文件夹
   *
   * @param menuCallback 回调
   */
  createRenameMenuInfoList(menuCallback: Function): Array<MenuInfo> {
    const menuInfoList = new Array<MenuInfo>();
    const renameMenu: MenuInfo = this.createMenuInfo(CommonConstants.MENU_TYPE_DYNAMIC,
    StyleConstants.DEFAULT_RENAME_IMAGE, $r('app.string.rename_folder'));
    renameMenu.onMenuClick = (): void => {
      log.showInfo('Launcher click menu to rename');
      menuCallback();
    };
    menuInfoList.push(renameMenu);
    return menuInfoList;
  }

  /**
   * ShortcutInfo菜单栏
   *
   * @param value
   */
  createShortcutInfoMenuInfoList(value: IShortCutInfo): MenuInfo {
    let menu: MenuInfo = this.createMenuInfo(CommonConstants.MENU_TYPE_DYNAMIC, value.icon, value.label);
    menu.shortcutIconId = value.iconId;
    menu.shortcutLabelId = value.labelId;
    menu.bundleName = value.bundleName;
    menu.moduleName = value.moduleName;
    return menu;
  }

  /**
   * 注册上下文菜单接口
   *
   * @param contentId 卡片：卡片ID；其它：未定义
   * @param listener 接口
   */
  registerContextMenuListener(contentId: string, listener: ContextMenuListener): void {
    if (CheckEmptyUtils.checkStrIsEmpty(contentId) || contentId === '0' || CheckEmptyUtils.isEmpty(listener)) {
      log.showWarn('registerContextMenuListener invalid input');
      return;
    }

    this.mMenuListenerMap.set(contentId, listener);
  }

  /**
   * 解注册上下文菜单接口
   *
   * @param contentId 卡片：卡片ID；其它：未定义
   */
  unregisterContextMenuListener(contentId: string): void {
    if (CheckEmptyUtils.checkStrIsEmpty(contentId) || contentId === '0') {
      log.showWarn('unregisterContextMenuListener invalid input');
      return;
    }

    this.mMenuListenerMap.delete(contentId);
  }

  /**
   * 获取上下文菜单接口
   *
   * @param contentId 卡片：卡片ID；其它：未定义
   */
  getContextMenuListener(contentId: string): ContextMenuListener | undefined {
    if (CheckEmptyUtils.checkStrIsEmpty(contentId) || contentId === '0') {
      log.showWarn('getContextMenuListener invalid input params %{public}s', contentId);
      return undefined;
    }

    const listener = this.mMenuListenerMap.get(contentId);
    if (CheckEmptyUtils.isEmpty(listener)) {
      log.showWarn('getContextMenuListener can not find %{public}s', contentId);
      return undefined;
    }
    return listener;
  }
}

export interface IShortCutInfo {
  icon: string;
  label: Resource;
  iconId: number;
  labelId: number;
  bundleName: string;
  moduleName: string;

}