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
import {
  AppItemInfo,
  CardItemInfo,
  CommonConstants, FormModel,
  FormManager,
  AppModel,
  ShortcutInfo,
  ShortcutViewModel,
  StyleConstants,
} from '@ohos/launchercommon';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import {
  TemplateCardInfo,
  FormCenterLocation,
} from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { launcherStatusUtil, ResUtils } from '@ohos/windowscene';
import { ResourceManager } from '@ohos/frameworkwrapper';
import { FormCenterViewModel } from '../FormCenterViewModel';

const TAG = 'SwiperLayoutViewData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class SwiperLayoutViewData {
  public appFormList: CardItemInfo[] = [];
  public formIdMap: Map<number, string> = new Map();
  public swipeTargetIndex: number = 0;
  public appInfo: AppItemInfo = new AppItemInfo();
  public mStartFormInfo: CardItemInfo = new CardItemInfo();
  public isAddToNegativeScreen: boolean = false;
  public isAsdeOpen: boolean = false;

  public initViewData(appInfo: AppItemInfo, startFormInfo: CardItemInfo, templateCardList?: TemplateCardInfo[]): void {
    log.showInfo(`initViewData ${appInfo.bundleName}, templateCardList: ${templateCardList?.length}`);
    this.appInfo = appInfo;
    let formModel: FormModel = FormModel.getInstance();
    let formList: CardItemInfo[] | undefined = [];
    if (FormCenterViewModel.getInstance().isScreenLock) {
      formList = formModel.getAppItemTotalFormInfo(appInfo.bundleName,
        (item: CardItemInfo) => formModel.isScreenLockSupportCard(item));
    } else {
      formList = formModel.getAppItemTotalFormInfo(appInfo.bundleName,
        (item: CardItemInfo) => formModel.isFormCenterSupportCard(item));
    }
    // formConfig里配置的所有卡片信息，包括不显示在卡片中心的卡片
    let allFormList: CardItemInfo[] | undefined = formModel.getAppItemTotalFormInfo(appInfo.bundleName);
    if (templateCardList?.length && !CheckEmptyUtils.isEmpty(startFormInfo) && allFormList?.length) {
      if (this.showTargetAppFormList(allFormList, templateCardList, startFormInfo)) {
        this.mStartFormInfo = new CardItemInfo();
        this.swipeTargetIndex = 0;
        return;
      }
    }

    this.isAsdeOpen = FormCenterViewModel.getInstance().isAsdeOpen;
    this.isAddToNegativeScreen = FormCenterViewModel.getInstance().isShowButtonByAsdeForNegativeScreen() ||
      FormCenterViewModel.getInstance().isShowButtonByNegativeScreenOpen();

    log.showWarn(`get ${appInfo.bundleName} formList length: ${formList?.length}`);
    if (CheckEmptyUtils.isEmpty(formList)) {
      log.showError(`${appInfo.bundleName} get form info failed`);
      return;
    }

    this.appFormList = [];
    // 获取一键锁屏快捷方式，展示在第一页，不显示在负一屏
    if ((appInfo.bundleName === CommonConstants.SCENEBOARD_BUNDLE) && !this.isAddToNegativeScreen) {
      this.getSceneBoardShortcut(appInfo);
    }
    this.appFormList.push(...formList as CardItemInfo[]);
    if (appInfo.bundleName === CommonConstants.THEME_MANAGER_BUNDLE) {
      let lastFormItem: CardItemInfo = new CardItemInfo();
      lastFormItem.bundleName = 'lastPage';
      this.appFormList.push(lastFormItem);
    }
    // 没有传入目标卡片时，一键锁屏卡片管理默认定位到一键锁屏快捷图标
    if (appInfo.bundleName === CommonConstants.SCENEBOARD_BUNDLE && CheckEmptyUtils.isEmpty(startFormInfo)) {
      this.swipeTargetIndex = 0;
      return;
    }
    this.swipeTargetIndex = FormCenterViewModel.getInstance().getAppFormsIndex(startFormInfo, this.appFormList);
  }

  /**
   * 获取一键锁屏快捷方式
   */
  private getSceneBoardShortcut(appInfo: AppItemInfo): void {
    // 优先从缓存里获取快捷方式，获取不到再去BMS获取
    let shortcutInfos: ShortcutInfo[] | undefined = [];
    shortcutInfos = AppModel.getInstance().getShortcutInfo(CommonConstants.SCENEBOARD_BUNDLE);
    if (CheckEmptyUtils.isEmptyArr(shortcutInfos)) {
      shortcutInfos = AppModel.getInstance().getShortcutInfoFromManagerSync(CommonConstants.SCENEBOARD_BUNDLE);
    }
    let scbShortcutInfo: ShortcutInfo | undefined =
      shortcutInfos?.find(item => item.id === CommonConstants.ONEKEY_LOCK_SHORTCUT_ID);
    if (scbShortcutInfo === undefined || CheckEmptyUtils.isEmpty(scbShortcutInfo)) {
      log.showWarn('the shortcut info of sceneBoard is empty');
      return;
    }
    let lastFormItem: CardItemInfo = new CardItemInfo();
    lastFormItem.shortcutInfo = scbShortcutInfo;
    lastFormItem.id = scbShortcutInfo.id;
    lastFormItem.bundleName = scbShortcutInfo.bundleName;
    lastFormItem.description = ResUtils.getInnerString($r('app.string.onekeylock_shortcut'));
    lastFormItem.cardDimension = CommonConstants.CARD_DIMENSION_1x1;
    lastFormItem.area = [1, 1];
    lastFormItem.cardId = '';
    lastFormItem.appName = appInfo.appName;
    lastFormItem.keyName =
      `${scbShortcutInfo.bundleName}${appInfo.abilityName ?? ''}${scbShortcutInfo.moduleName ?? ''}${scbShortcutInfo.appIndex ?? 0}${scbShortcutInfo.id ?? ''}`;
    this.appFormList.push(lastFormItem);
  }

  /**
   * 应用内拉起卡片管理显示特定卡片
   */
  private showTargetAppFormList(
    formList: CardItemInfo[], templateCardList: TemplateCardInfo[], startFormInfo: CardItemInfo): boolean {
    let targetForm: CardItemInfo | undefined = formList.find(i => i.cardName === startFormInfo.cardName);
    if (CheckEmptyUtils.isEmpty(targetForm)) {
      log.showInfo('app not template card in formConfig');
      return false;
    }
    this.appFormList = [];
    templateCardList.forEach(i => {
      log.showInfo(`description: ${i.description}, targetLabel: ${i.label}, dimension: ${i.dimension}`);
      let targetFormInfo: CardItemInfo = new CardItemInfo();
      ObjectCopyUtil.deepClone(targetForm, targetFormInfo);
      targetFormInfo.cardDimension = i.dimension;
      targetFormInfo.area = FormManager.getInstance().getCardSize(i.dimension);
      targetFormInfo.targetFormData = i.formData;
      targetFormInfo.targetDescription = i.description;
      targetFormInfo.targetLabel = i.label;
      this.appFormList.push(targetFormInfo);
    });
    return true;
  }
}
