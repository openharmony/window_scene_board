/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { bundleManager } from '@kit.AbilityKit';
import { GlobalContext } from '@ohos/frameworkwrapper';
import {
  CardItemInfo,
  CommonConstants,
  ContextMenuListener,
  editModeManager,
  Extend1Data,
  FormLayoutCacheManager,
  FormStackEventIdUtil,
  FormCommonUtil,
  layoutLockUtil,
  lockLayoutManager,
  MenuInfo,
  MenuInfoManager,
} from '@ohos/launchercommon';
import {
  FormEditViewManager,
  FormEditViewParam
} from '@ohos/launchercommon/src/main/ets/manager/FormEditViewManager';
import {
  FormStackHiSysEventUtil,
  ShortcutMenuClickEvent,
  ShortcutMenuClickItem
} from '../common/FormStackHiSysEventUtil';
import { FormStackItemInfo } from '../common/FormStackItemInfo';
import { FormStackManager } from '../common/FormStackManager';
import { FormStackConstants } from '../common/FormStackConstants';
import { FormStackViewModel } from './FormStackViewModel';
import CardLockManager from '@ohos/launchercommon/src/main/ets/manager/CardLockManager';
import CardLockUtils from '@ohos/launchercommon/src/main/ets/utils/CardLockUtils';

const TAG: string = 'FormStackMenuViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

/**
 * 堆叠菜单
 *
 * @since 2024-02-26
 */
export class FormStackMenuViewModel {
  private readonly mFormStackItem: FormStackItemInfo = new FormStackItemInfo();
  private readonly mDesktopContext: ServiceExtensionContext = GlobalContext.getContext();
  private mFormEditViewManager: FormEditViewManager = FormEditViewManager.getInstance();

  constructor(formStackItem: FormStackItemInfo) {
    this.mFormStackItem = formStackItem;
  }

  public getFormMenuInFormStack(formInfo: CardItemInfo, coverForm: CardItemInfo | undefined, menuName: string,
                                deleteFunc: () => void): MenuInfo[] {
    log.showWarn(`current cardId: ${formInfo.cardId}, bundleName is: ${formInfo.bundleName}, menuName: ${menuName}`);
    const menuInfoList: MenuInfo[] = this.getContextMenuList(formInfo);
    const ret = menuInfoList.length ? menuInfoList : this.getCardMenuList(formInfo, coverForm, menuName, deleteFunc);
    if (CardLockManager.getInstance().mainAppHasLock(formInfo.bundleName)) {
      ret.unshift(CardLockUtils.getInstance().buildAppLockMenu(formInfo));
    }
    return ret;
  }

  public getFormStackMenuInfoList(formInfo: CardItemInfo): Array<MenuInfo> {
    const expandForm: MenuInfo = MenuInfoManager.getInstance().createMenuInfo(CommonConstants.MENU_TYPE_FIXED,
      '/common/pics/ic_desktop_servicewidgets.svg', $r('app.string.expand_formstack'));
    expandForm.onMenuClick = () => { this.expandFormStack(formInfo); };
    return [expandForm];
  }

  private editForm(formInfo: CardItemInfo): void {
    log.showInfo(`Click menu item into form edit view:${formInfo.formConfigAbility}`);
    const abilityName: string =
      String(formInfo.formConfigAbility).slice(CommonConstants.FORM_CONFIG_ABILITY_PREFIX.length) ?? '';
    const event: ShortcutMenuClickEvent = {
      type: ShortcutMenuClickItem.ITEM_EDIT,
      formStackID: this.mFormStackItem.formStackId as string,
      area: this.mFormStackItem.area,
      topCardPackageName: formInfo.bundleName,
      sourceType: Extend1Data.getCardSourceType(formInfo.extend1),
      formType: FormCommonUtil.getFormType(formInfo.gameCardInfo),
    };
    FormStackHiSysEventUtil.reportClickShortcutMenu(event);

    if (!this.mDesktopContext) {
      log.showError('mDesktopContext is invalid!');
      new FormStackViewModel().jumpToForm(abilityName, formInfo.bundleName, formInfo.moduleName, formInfo.cardId);
      return;
    }

    this.mDesktopContext.eventHub.off(FormStackConstants.EVENTHUB_FORMSTACK_MENU_DISAPPEAR);
    this.mDesktopContext.eventHub.on(FormStackConstants.EVENTHUB_FORMSTACK_MENU_DISAPPEAR, () => {
      this.mDesktopContext.eventHub.off(FormStackConstants.EVENTHUB_FORMSTACK_MENU_DISAPPEAR);
      if (this.mFormEditViewManager.isFormEditExtensionAbility(formInfo.bundleName, abilityName)) {
        let param: FormEditViewParam = new FormEditViewParam();
        param.bundleName = formInfo.bundleName;
        param.formInfo = formInfo;
        this.mFormEditViewManager.openFormEditView(param);
      } else {
        new FormStackViewModel().jumpToForm(abilityName, formInfo.bundleName, formInfo.moduleName, formInfo.cardId);
      }
    });
  }

  private expandFormStack(formInfo: CardItemInfo): void {
    log.showInfo('click menu item to expand formstack.');
    const event: ShortcutMenuClickEvent = {
      type: ShortcutMenuClickItem.ITEM_EXPAND,
      formStackID: this.mFormStackItem.formStackId as string,
      area: this.mFormStackItem.area,
      topCardPackageName: formInfo.bundleName,
      sourceType: Extend1Data.getCardSourceType(formInfo.extend1),
      formType: FormCommonUtil.getFormType(formInfo.gameCardInfo),
    };
    FormStackHiSysEventUtil.reportClickShortcutMenu(event);

    const openFormStackEventId: string = FormStackEventIdUtil.getOpenFormStackEventId(this.mFormStackItem.formStackId);
    this.mDesktopContext?.eventHub.emit(openFormStackEventId);
  }

  private getContextMenuList(formInfo: CardItemInfo): MenuInfo[] {
    const listener: ContextMenuListener | undefined =
      MenuInfoManager.getInstance().getContextMenuListener(formInfo.cardId);
    return listener?.onMenuBuild(CommonConstants.TYPE_FORM_STACK, ResponseType.LongPress) ?? [];
  }

  private hasAuthToEditForm(formInfo: CardItemInfo): boolean {
    return Boolean(formInfo.formConfigAbility &&
      String(formInfo.formConfigAbility).startsWith(CommonConstants.FORM_CONFIG_ABILITY_PREFIX, 0) &&
      (!CardLockManager.getInstance().mainAppHasLock(formInfo.bundleName) ||
      CardLockManager.getInstance().getLockedCardIsReleased(formInfo.bundleName, formInfo.cardId)))
  }

  private getCardMenuList(formInfo: CardItemInfo,
    coverForm: CardItemInfo | undefined, menuName: string, deleteFunc: () => void): MenuInfo[] {
    const menuInfoList: MenuInfo[] = [];
    let appName: string = `“${menuName}”`;
    if (this.hasAuthToEditForm(formInfo)) {
      const editForm: MenuInfo = MenuInfoManager.getInstance().createMenuInfo(CommonConstants.MENU_TYPE_FIXED,
        '/common/pics/ic_public_edit.svg', $r('app.string.edit_formstack', appName));
      editForm.onMenuClick = (): void => { this.editForm(formInfo); };
      menuInfoList.push(editForm);
    }

    if (deleteFunc !== null && !layoutLockUtil.isLockedPage(this.mFormStackItem.page, 'get form removeMenu for Stack',
      true) && !lockLayoutManager.isLockLayout()) {
      const deleteFormFromFormStack: MenuInfo =
        MenuInfoManager.getInstance().createMenuInfo(CommonConstants.MENU_TYPE_FIXED,
          '/common/pics/ic_public_remove.svg', $r('app.string.delete_formstack', appName));
      deleteFormFromFormStack.onMenuClick = () => {
        log.showWarn(`click menu item remove form of formstack, cover form: ${coverForm?.cardId}`);
        this.mDesktopContext.eventHub.off(FormStackConstants.EVENTHUB_FORMSTACK_MENU_DISAPPEAR);
        this.mDesktopContext.eventHub.on(FormStackConstants.EVENTHUB_FORMSTACK_MENU_DISAPPEAR, () => {
          this.mDesktopContext.eventHub.off(FormStackConstants.EVENTHUB_FORMSTACK_MENU_DISAPPEAR);
          deleteFunc();
        });
      };

      menuInfoList.push(deleteFormFromFormStack);
    }
    return menuInfoList;
  }
}