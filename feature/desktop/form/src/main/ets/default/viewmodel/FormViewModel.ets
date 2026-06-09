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
import { launcherStatusUtil } from '@ohos/windowscene';
import {
  Extend1Data,
  FormHiSysEventReporter,
  FormLayoutCacheManager,
  FormModel,
  FormCommonUtil,
  GridLayoutItemInfo,
  LauncherLayoutCacheUtil
} from '@ohos/launchercommon';
import { PageDesktopViewModelProxy, IPageDesktopViewModel } from '@ohos/launchercommon/Index';
import type { ClickAddCardEvent } from '@ohos/launchercommon';
import { SettingsModel } from '@ohos/launchercommon';
import { CommonConstants } from '@ohos/launchercommon';
import { RdbStoreManager } from '@ohos/launchercommon';
import { layoutConfigManager } from '@ohos/launchercommon';
import { FormListInfoCacheManager } from '@ohos/launchercommon';
import { FormStyleConfig } from '../common/FormStyleConfig';
import { CardItemInfo } from '@ohos/launchercommon';
import FeatureConstants from '../common/constants/FeatureConstants';
import { StyleConstants } from '@ohos/launchercommon';
import {
  LogHelper,
  LogDomain,
  CheckEmptyUtils,
  SingleBase,
  SingleContext,
  singleManager
} from '@ohos/basicutils';
import type { RectInfo } from '@ohos/basicutils';
import { CardAddType } from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { BusinessType, RdbHandleResult } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';

const TAG = 'FormViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
const KEY_FORM_LIST = 'formListInfo';
// vde外屏图标大小
const SMALL_FOLD_OUTER_ICON_SIZE = 52;

/**
 * Class FormViewModel.
 */
export class FormViewModel extends SingleBase {
  public static singleName: string = 'FormViewModel';
  private readonly mFormModel: FormModel;
  private readonly mFormStyleConfig: FormStyleConfig;
  private readonly mSettingsModel: SettingsModel;
  private mLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
  private mPageDesktopViewModelProxy: IPageDesktopViewModel = PageDesktopViewModelProxy.getInstance()

  constructor(ctx?: SingleContext) {
    super(ctx);
    log.showInfo('constructor start');
    this.mFormModel = FormModel.getInstance();
    this.mSettingsModel = SettingsModel.getInstance();
    this.mFormStyleConfig = layoutConfigManager.getStyleConfig(FormStyleConfig.APP_LIST_STYLE_CONFIG,
      FeatureConstants.FEATURE_NAME);
  }

  /**
   * Get the form view model object.
   *
   * @return {object} form view model singleton
   */
  static getInstance(ctx?: SingleContext): FormViewModel {
    return singleManager.get<FormViewModel>(FormViewModel, ctx);
  }

  /**
   * Get the form style config info.
   *
   * @return {object} mFormStyleConfig - get the style from layout config manager.
   */
  getFormStyleConfig(): FormStyleConfig {
    return this.mFormStyleConfig;
  }

  async updateCardIdOfPreloadForm(cardItemInfo: CardItemInfo, newCardId: string,
    isOuterDeskTop: boolean = false): Promise<void> {
    cardItemInfo.cardId = newCardId;
    let updateItemInfo: GridLayoutItemInfo | undefined =
      this.mLayoutManager.selectGridLayoutItemByPosition(cardItemInfo.page, cardItemInfo.row, cardItemInfo.column,
        isOuterDeskTop);
    if (!updateItemInfo || updateItemInfo.typeId !== CommonConstants.TYPE_CARD) {
      log.showError(`Position duplicates, itemType: ${updateItemInfo?.typeId}`);
      return;
    }
    let currentFormsInfo: CardItemInfo[] = await this.mFormModel.getFormsInfoFromMapAndManager(cardItemInfo.bundleName);
    let cardItem: CardItemInfo =
      currentFormsInfo?.find(item => item.cardName === cardItemInfo.cardName) as CardItemInfo;
    if (!CheckEmptyUtils.isEmpty(cardItem) && (cardItemInfo.formConfigAbility !== cardItem.formConfigAbility ||
      cardItemInfo.isTransparent !== cardItem.isTransparent)) {
      cardItemInfo.formConfigAbility = cardItem.formConfigAbility;
      cardItemInfo.isTransparent = cardItem.isTransparent;
      updateItemInfo.isTransparent = cardItem.isTransparent;
      updateItemInfo.formConfigAbility = cardItem.formConfigAbility;
      log.showInfo(`new configAbility:${cardItemInfo.formConfigAbility}, new trans: ${cardItemInfo.isTransparent}`);
    }

    log.showWarn(`PreloadForm updates cardId, oldCardId: ${updateItemInfo.cardId}, newCardId:${newCardId}`);
    updateItemInfo.cardId = newCardId;
    if (updateItemInfo.extend1) {
      updateItemInfo.extend1 = Extend1Data.unsetMigrateForm(updateItemInfo.extend1);
      cardItemInfo.extend1 = Extend1Data.unsetMigrateForm(cardItemInfo.extend1);
    }
    this.addFormInfoToFormList(cardItemInfo);
    const res: RdbHandleResult = await this.mLayoutManager.updateGridLayoutItemByPosition(cardItemInfo.page,
      cardItemInfo.row, cardItemInfo.column, updateItemInfo, BusinessType.BUSINESS_CARD, true, isOuterDeskTop);
    if (res === RdbHandleResult.FAIL) {
      let targetInfo: GridLayoutItemInfo = LauncherLayoutCacheUtil.getChangeItems([updateItemInfo])[0];
      this.mSettingsModel.registerPresetCardUpdateCallback(() => {
        RdbStoreManager.getInstance().updateFormInfoByPosition(targetInfo);
      });
    }
  }

  /**
   * 将卡片信息添加到formCache中
   *
   * @param cardItemInfo
   */
  public addFormInfoToFormList(cardItemInfo: CardItemInfo): void {
    let formInfoList: CardItemInfo[] = FormListInfoCacheManager.getInstance().getCache(KEY_FORM_LIST) as CardItemInfo[];
    if (!formInfoList || !Array.isArray(formInfoList)) {
      formInfoList = [];
    }
    (formInfoList as CardItemInfo[]).push(cardItemInfo);
    FormListInfoCacheManager.getInstance().setCache(KEY_FORM_LIST, formInfoList);
  }

  async updateCardIdOfFormStack(formStackId: string, cardItemInfo: CardItemInfo, newCardId: string,
    isOuter?: boolean): Promise<void> {
    if (!cardItemInfo || CheckEmptyUtils.checkStrIsEmpty(formStackId)) {
      log.showError('updateCardIdOfFormStack, input param invalid!');
      return;
    }

    let id: number = await LauncherLayoutCacheUtil.selectIdByFormStackId(formStackId, isOuter);
    if (id === CommonConstants.INVALID_VALUE) {
      log.showWarn('updateCardIdOfFormStack, formStackId is inactive!');
    }
    log.showInfo('updateCardIdOfFormStack formStackId: %{public}s, oldCardId: %{public}s, newCardId: %{public}s, ' +
      'bundleName: %{public}s, container: %{public}d.', formStackId, cardItemInfo.cardId, newCardId,
      cardItemInfo.bundleName, id);

    const oldCardId: string = cardItemInfo.cardId;
    const formStackItem: GridLayoutItemInfo | undefined =
      this.mLayoutManager.selectGridLayoutItemByFormstackId(formStackId, isOuter);
    if (!formStackItem?.layoutInfo?.[0] || CheckEmptyUtils.isEmptyArr(formStackItem?.layoutInfo?.[0])) {
      log.showError(`can not find formStackId: ${formStackId}.`);
      return;
    }

    const items: GridLayoutItemInfo[] = formStackItem.layoutInfo[0];
    const index: number = items.findIndex(item => {
      if (!CheckEmptyUtils.checkStrIsEmpty(oldCardId)) {
        return item.cardId === oldCardId && item.bundleName === cardItemInfo.bundleName;
      } else {
        return item.bundleName === cardItemInfo.bundleName;
      }
    });

    if (index < 0) {
      log.showError(`can not find item bundleName: ${cardItemInfo.bundleName}, index: ${index}.`);
      return;
    }
    let layoutItem: GridLayoutItemInfo = items[index];
    // 更新数据库
    const res: RdbHandleResult = await this.mLayoutManager.updateCardIdOfFormStack(formStackId,
      newCardId, cardItemInfo, id, isOuter);
    if (res === RdbHandleResult.FAIL) {
      this.mSettingsModel.registerPresetCardUpdateCallback(async () => {
        let id: number = await LauncherLayoutCacheUtil.selectIdByFormStackId(formStackId, false);
        layoutItem.container = id;
        RdbStoreManager.getInstance().updateCardIdOfFormStack(oldCardId, layoutItem, isOuter);
      });
    }
  }

  /**
   * 负一屏点击添加卡片
   * @param formItem
   * @param position
   * @param page
   * @param screenSelectType
   */
  public reportIntelligentAddCardEvent(formItem: CardItemInfo, position: number[], page: number,
    screenSelectType: number): void {
    let cardDimension: number = formItem.dimension;
    let dpSize = this.mFormStyleConfig.mFormWidth.get(String(cardDimension)) + '*' +
      this.mFormStyleConfig.mFormHeight.get(String(cardDimension));
    let event: ClickAddCardEvent = {
      packageName: formItem.bundleName,
      area: CardItemInfo.getCardSize(cardDimension),
      dpSize: dpSize,
      formId: formItem.id ?? '',
      moduleName: formItem.moduleName,
      formName: formItem.name ?? '',
      page: page,
      addType: CardAddType.AA_CARD_SHORTCUT_MENU_INTO_FORM_MANAGER,
      column: position[0],
      row: position[1],
      screenType: screenSelectType,
      formType: FormCommonUtil.getFormType(formItem.gameCardInfo),
    };
    FormHiSysEventReporter.reportAddCardToScreenByClick(event);
  }

  // 获取卡片管理快捷图标大小
  public getShortcutFormSize(): number {
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      return SMALL_FOLD_OUTER_ICON_SIZE;
    }
    return this.mPageDesktopViewModelProxy.getPageDesktopStyleConfig()?.mIconSize ?? 0;
  }

  // 获取卡片管理快捷图标圆角
  public getShortcutFormRadius(): number {
    return this.mPageDesktopViewModelProxy.getPageDesktopStyleConfig()?.mIconRadius ?? 0;
  }
}