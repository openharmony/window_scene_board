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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { FormConstants } from '@ohos/form';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  CardItemInfo,
  CommonConstants,
  FormCommonUtil,
  GridLayoutItemInfo,
  layoutLockUtil,
  lockLayoutManager,
  MenuInfo,
  MenuInfoManager,
} from '@ohos/launchercommon';
import CardLockManager from '@ohos/launchercommon/src/main/ets/manager/CardLockManager';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';
import { PortfolioInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/PortfolioInfo';
import CardLockUtils from '@ohos/launchercommon/src/main/ets/utils/CardLockUtils';
import { AiSuggestionConstants } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';
import { ResUtils } from '@ohos/windowscene';
import { DislikeOption } from '../constants/DispatchParamsConstant';
import { EventReportConstants } from '../constants/EventReportConstants';
import { ItemPinStatus } from '../constants/ItemPinStatus';
import { AiSuggestionEventReporter } from '../donate/AiSuggestionEventReporter';
import AiSuggestionActionManager from '../manager/AiSuggestionActionManager';
import { AiSuggestionUtil } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUtil';

const TAG = 'AiSuggestionMenuBuilder';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * menuBuilder for ai suggestion
 *
 * @since 2025-03-25
 */
export class AiSuggestionMenuBuilder {
  private menuInfos: MenuInfo[] = [];
  /**
   * 构建长按子服务菜单
   *
   * @param parentForm 母卡片
   * @param containerType 容器类型
   * @param childService 子服务
   * @param formDialog 弹窗
   * @returns 菜单数组
   */
  public buildChildServiceMenu(parentForm: GridLayoutItemInfo, containerType: number, childService?: LauncherRecItem,
    formDialog?: CustomDialogController): MenuInfo[] {
    if (containerType === CommonConstants.CONTAINER_DESKTOP) {
      return this.buildChildServiceMenus(parentForm, childService, formDialog);
    }

    if (containerType === CommonConstants.TYPE_FORM_STACK) {
      return this.buildFormStackChildServiceMenus(parentForm, childService);
    }
    return [];
  }

  /**
   * 构建长按母卡片菜单
   *
   * @param parentForm 母卡片
   * @param containerType 容器类型
   *@param portfolioInfo 场景信息
   * @param formDialog 弹窗
   * @returns 菜单数组
   */
  public buildParentServiceMenu(parentForm: GridLayoutItemInfo, containerType: number, portfolioInfo?: PortfolioInfo,
    formDialog?: CustomDialogController): MenuInfo[] {
    if (containerType === CommonConstants.CONTAINER_DESKTOP) {
      return this.buildParentMenus(parentForm, formDialog);
    }

    if (containerType === CommonConstants.TYPE_FORM_STACK) {
      return this.buildFormStackParentMenus(parentForm, portfolioInfo);
    }
    return [];
  }

  /**
   * 构建外屏菜单
   *
   * @param containerType 容器类型
   * @param parentForm 母卡片
   * @returns 菜单数组
   */
  public buildExternalMenu(containerType: number, parentForm: GridLayoutItemInfo): MenuInfo[] {
    if (!parentForm) {
      log.showWarn('buildExternalMenu parentForm null');
      return this.menuInfos;
    }

    if (containerType === CommonConstants.CONTAINER_DESKTOP) {
      this.buildRemoveMenu(parentForm);
    } else if (containerType === CommonConstants.TYPE_FORM_STACK) {
      this.buildRemoveMenuInFormStack(parentForm);
    }
    return this.menuInfos;
  }

  private buildParentMenus(parentForm: GridLayoutItemInfo, formDialog?: CustomDialogController): MenuInfo[] {
    if (!parentForm) {
      log.showWarn('buildParentMenus parentForm null');
      return this.menuInfos;
    }
    this.buildManageCardMenu(parentForm);
    if (!layoutLockUtil.isLockedPage(parentForm.page, 'get ai parent removeMenu')) {
      this.buildRemoveMenu(parentForm);
    }

    this.buildMoreServiceFormMenu(parentForm, formDialog);
    return this.menuInfos;
  }

  private buildChildServiceMenus(parentForm: GridLayoutItemInfo, childService?: LauncherRecItem,
    formDialog?: CustomDialogController): MenuInfo[] {
    if (!parentForm || !childService) {
      log.showWarn('buildChildServiceMenus parentForm or childService null');
      return this.menuInfos;
    }
    this.buildCommonChildMenu(parentForm, childService);
    if (childService.dimension === parentForm.cardDimension &&
      !layoutLockUtil.isLockedPage(parentForm.page, 'get ai child removeMenu')) {
      this.buildRemoveMenu(parentForm);
    }

    this.buildMoreServiceFormMenu(parentForm, formDialog);
    return this.menuInfos;
  }

  private buildFormStackChildServiceMenus(parentForm: GridLayoutItemInfo, childService?: LauncherRecItem): MenuInfo[] {
    if (!parentForm || !childService) {
      log.showWarn('buildFormStackChildServiceMenus parentForm or childService null');
      return this.menuInfos;
    }
    this.buildCommonChildMenu(parentForm, childService);
    if (childService.dimension === parentForm.cardDimension &&
      !layoutLockUtil.isLockedPage(parentForm.page, 'get ai child removeMenu')) {
      this.buildRemoveMenuInFormStack(parentForm);
    }
    return this.menuInfos;
  }

  private buildFormStackParentMenus(parentForm: GridLayoutItemInfo, portfolioInfo?: PortfolioInfo): MenuInfo[] {
    if (!parentForm) {
      log.showWarn('buildFormStackParentMenus parentForm null');
      return this.menuInfos;
    }
    this.buildManageCardMenu(parentForm);
    if (!layoutLockUtil.isLockedPage(parentForm.page, 'get ai parent removeMenu') &&
      (PortfolioInfo.isMainCard(portfolioInfo?.portfolioId ?? '') || portfolioInfo?.portfolioId === 'discovery')) {
      this.buildRemoveMenuInFormStack(parentForm);
    }
    return this.menuInfos;
  }

  private buildCommonChildMenu(parentForm: GridLayoutItemInfo, childService: LauncherRecItem): void {
    if (childService.itemType === CommonConstants.TYPE_CARD &&
    CardLockManager.getInstance().mainAppHasLock(childService.bundleName)) {
      this.buildAppLockMenu(childService);
    }
    this.buildReduceRecommendServiceMenu(parentForm, childService);
    this.buildNotRecommendServiceMenu(parentForm, childService);

    if (childService.itemType === AiSuggestionConstants.TYPE_APP) {
      this.buildSubScribeMenu(parentForm, childService, $r('app.string.pin_this_app'), $r('app.string.unpin_this_app'));
      this.buildManageAppMenu(parentForm);
    }
    if (childService.itemType === AiSuggestionConstants.TYPE_CARD) {
      this.buildSubScribeMenu(parentForm, childService, $r('app.string.subscribe_this_card'), $r('app.string.unsubscribe_this_card'));
      this.buildManageCardMenu(parentForm);
    }
  }

  private buildAppLockMenu(childService: LauncherRecItem): void {
    const formInfo = new CardItemInfo();
    formInfo.cardId = FormCommonUtil.transformCardId(childService.cardId);
    formInfo.cardName = childService.formName;
    formInfo.extend1 = childService.extend1;
    formInfo.moduleName = childService.moduleName;
    formInfo.bundleName = childService.bundleName;
    formInfo.cardDimension = childService.dimension;
    formInfo.area = CardItemInfo.getCardSize(childService.dimension);
    this.menuInfos.push(CardLockUtils.getInstance().buildAppLockMenu(formInfo));
  }

  private buildReduceRecommendServiceMenu(parentForm: GridLayoutItemInfo,
    childService: LauncherRecItem): void {

    if (AiSuggestionUtil.isVoiceAbilityForm(childService.bundleName, childService.abilityName)) {
      log.showInfo('buildReduceRecServiceMenu isVoiceAbilityForm');
      return;
    }

    if (childService.pinStatus === ItemPinStatus.PINED) {
      log.showInfo('buildReduceRecServiceMenu childService is pined, do not show dislike menu');
      return;
    }

    if (childService.itemType === AiSuggestionConstants.TYPE_APP) {
      log.showInfo('buildReduceRecommendServiceMenu childService is app, do not show dislike menu');
      return;
    }

    this.menuInfos.push(this.buildMenuInfo(
      CommonConstants.MENU_TYPE_FIXED,
      '/common/pics/ic_not_interested.svg',
      $r('app.string.reduce_recommend_this_card'),
      (): void => {
        log.showInfo('click reduce recommend service in ai suggestion');
        AiSuggestionActionManager.getInstance()
          .dislikeService(parentForm, childService, DislikeOption.LOWER_FREQUENCY);
        AiSuggestionEventReporter.getInstance().setMenuType(EventReportConstants.SUGGEST_MENU_TYPE_UNINTEREST);
      }
    ));
  }

  private buildNotRecommendServiceMenu(parentForm: GridLayoutItemInfo,
    childService: LauncherRecItem): void {
    if (AiSuggestionUtil.isVoiceAbilityForm(childService.bundleName, childService.abilityName)) {
      log.showInfo('buildNotRecommendServiceMenu isVoiceAbilityForm');
      return;
    }

    if (childService.pinStatus === ItemPinStatus.PINED) {
      log.showInfo('buildNotRecommendServiceMenu childService is pined, do not show notRecommend menu');
      return;
    }

    this.menuInfos.push(this.buildMenuInfo(
      CommonConstants.MENU_TYPE_FIXED,
      '/common/pics/ic_public_remove.svg',
      childService.itemType === AiSuggestionConstants.TYPE_APP ?
      $r('app.string.not_recommend_this_app') : $r('app.string.not_recommend_this_card'),
      (): void => {
        log.showInfo('click notRecommendService in ai suggestion');
        AiSuggestionActionManager.getInstance().dislikeService(parentForm, childService, DislikeOption.ADD_BLACKLIST);
        AiSuggestionEventReporter.getInstance().setMenuType(EventReportConstants.SUGGEST_MENU_TYPE_UNINTEREST);
      }
    ));
  }

  private buildSubScribeMenu(parentForm: GridLayoutItemInfo, childService: LauncherRecItem,
    pinRes: Resource, unPinRes: Resource): void {
    if (CheckEmptyUtils.isEmpty(childService.pinStatus)) {
      log.showError('buildSubScribeMenu childService pin status is invalid');
      return;
    }
    if (childService.pinStatus === ItemPinStatus.NOT_SUPPORT_PIN) {
      log.showInfo('buildSubScribeMenu childService is not support pin');
      return;
    }

    log.showInfo('buildSubScribeMenu serviceId = %{public}s pin status is %{public}d', childService.serviceId,
      childService.pinStatus);
    const isUnpin = childService.pinStatus === ItemPinStatus.UNPIN;
    this.menuInfos.push(this.buildMenuInfo(
      CommonConstants.MENU_TYPE_FIXED,
      isUnpin ? '/common/pics/ic_pin.svg' : '/common/pics/ic_not_pin.svg',
      isUnpin ? pinRes : unPinRes,
      (): void => {
        log.showInfo('click menu item subScribe or unSubScribe');
        if (isUnpin) {
          AiSuggestionActionManager.getInstance().pinRecItem(childService, parentForm);
          AiSuggestionEventReporter.getInstance().setMenuType(EventReportConstants.SUGGEST_MENU_TYPE_PIN);
        } else {
          AiSuggestionActionManager.getInstance().unpinRecItem(childService, parentForm);
          AiSuggestionEventReporter.getInstance().setMenuType(EventReportConstants.SUGGEST_MENU_TYPE_UNPIN);
        }
      }
    ));
  }

  private buildManageCardMenu(parentForm: GridLayoutItemInfo): void {
    this.menuInfos.push(this.buildMenuInfo(
      CommonConstants.MENU_TYPE_FIXED,
      '/common/pics/ic_public_edit.svg',
      $r('app.string.manage_card'),
      (): void => {
        AiSuggestionActionManager.getInstance().manageCard(parentForm);
      }
    ));
  }

  private buildManageAppMenu(parentForm: GridLayoutItemInfo): void {
    this.menuInfos.push(this.buildMenuInfo(
      CommonConstants.MENU_TYPE_FIXED,
      '/common/pics/ic_public_edit.svg',
      $r('app.string.manage_app'),
      (): void => {
        AiSuggestionActionManager.getInstance().manageApp(parentForm);
      }
    ));
  }

  private buildRemoveMenuInFormStack(parentForm: GridLayoutItemInfo): void {
    if (lockLayoutManager.isLockLayout()) {
      return;
    }
    const appName = ResUtils.getInnerString($r('app.string.aisuggestion_app_name'));
    this.menuInfos.push(this.buildMenuInfo(
      CommonConstants.MENU_TYPE_FIXED,
      '/common/pics/ic_public_remove.svg',
      $r('app.string.delete_formstack', `“${appName}”`),
      (): void => {
        log.showInfo('click menu item remove ai suggestion from formstack');
        AiSuggestionActionManager.getInstance().removeForm(parentForm);
        AiSuggestionEventReporter.getInstance().setMenuType(EventReportConstants.SUGGEST_MENU_TYPE_REMOVE);
      }
    ));
  }

  private buildRemoveMenu(parentForm: GridLayoutItemInfo): void {
    if (lockLayoutManager.isLockLayout()) {
      return;
    }
    this.menuInfos.push(this.buildMenuInfo(
      CommonConstants.MENU_TYPE_FIXED,
      '/common/pics/ic_public_remove.svg',
      $r('app.string.delete_form'),
      (): void => {
        log.showInfo('click menu item remove ai suggestion');
        AiSuggestionActionManager.getInstance().removeForm(parentForm);
        AiSuggestionEventReporter.getInstance().setMenuType(EventReportConstants.SUGGEST_MENU_TYPE_REMOVE);
      }
    ));
  }

  private buildMoreServiceFormMenu(parentForm: GridLayoutItemInfo,
    moreFormDialog?: CustomDialogController): void {
    this.menuInfos.push(MenuInfoManager.getInstance().createMoreServiceFormMenuInfo(
      parentForm,
      moreFormDialog,
      DeviceHelper.isPC(),
      parentForm.appName,
      FormConstants.FORM_MANAGER_SHOW_FROM_DESKTOP_FORM_RIGHT_MENU,
      () => AiSuggestionEventReporter.getInstance().setMenuType(EventReportConstants.SUGGEST_MENU_TYPE_MORE_CARD),
    ));
  }

  private buildMenuInfo(menuType: number, menuImgSrc: string, menuText: Resource, onMenuClick: Function): MenuInfo {
    const menu = new MenuInfo();
    menu.menuType = menuType;
    menu.menuImgSrc = menuImgSrc;
    menu.menuText = menuText;
    menu.onMenuClick = onMenuClick;
    return menu;
  }
}