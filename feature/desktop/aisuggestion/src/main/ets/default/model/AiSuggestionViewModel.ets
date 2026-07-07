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

import {
  CardItemInfo,
  FormModel,
  GridLayoutItemInfo,
  LauncherAnimUtil,
  PageDesktopModel,
} from '@ohos/launchercommon';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { DeviceHelper, } from '@ohos/frameworkwrapper';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ObjectCopyUtil, SCBVisualEffectMgr } from '@ohos/componenthelper';
import { ResUtils, sSCBOobeManager } from '@ohos/windowscene';
import { PageDesktopGridStyleConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/PageDesktopGridStyleConfig';
import { AiSuggestionComponentData } from '../bean/AiSuggestionComponentData';
import { AbilityFormUtil } from '../utils/AbilityFormUtil';
import { LauncherCardInfo } from '../bean/LauncherCardInfo';
import { AiSuggestionAppGroupManager } from '../manager/AiSuggestionAppGroupManager';
import { AiSuggestionFormManager } from '../manager/AiSuggestionFormManager';
import { AiSuggestionLayoutStyle } from '../config/AiSuggestionLayoutStyle';
import { PortfolioInfoDisplayMode } from '../constants/PortfolioInfoDisplayMode';
import { LanguageUtil } from '../utils/LanguageUtil';
import { OperateFormStackHelper } from '../manager/OperateFormStackHelper';
import { AiSuggestionEvent } from '../event/AiSuggestionEvent';
import { AiSuggestionDataHelper } from '../helper/AiSuggestionDataHelper';
import { AiSuggestionDataProcess } from '../helper/AiSuggestionDataProcess';
import { ExtraData } from '@ohos/launchercommon/src/main/ets/aisuggestion/ExtraData';
import { LauncherDisplayCardInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherDisplayCardInfo';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';
import { PortfolioInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/PortfolioInfo';
import { CardResourceInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/CardResourceInfo';
import {
  AiSuggestionConstants,
  LongPressType
} from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';

const TAG = 'AiSuggestionViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 语音助手建议AiSuggestionComponent组件Vm
 *
 * @since 2025-05-27
 */
export class AiSuggestionViewModel {
  public viewData: AiSuggestionComponentData = new AiSuggestionComponentData();
  public formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
  public cardId: string = '';
  public curColorMode: ConfigurationConstant.ColorMode = ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
  public layoutStyle?: AiSuggestionLayoutStyle;
  public isOuterDesktop = false;
  public changedItemIdsSet: Set<string> = new Set<string>();
  public disappearLastIndex: number = 0;
  public isNewAddedComponent: boolean = false;
  public mIsDuringAppExitAnim: boolean = false;
  public isFormStackChildItem: boolean = false;
  public mEvent?: AiSuggestionEvent;
  public updateAppName?: Function;
  public deleteForm?: Function;
  public isUseEffect?: Function;
  public isDuringAppExitAnimFunction?: Function;
  public updateCardSuccess?: Function;
  public getCropWallPaperPixelMap?: Function;

  public initEvent(cardId: string | undefined, formItem: GridLayoutItemInfo): void {
    if (!cardId) {
      log.showError('initEvent fail');
      return;
    }
    if (!this.mEvent) {
      this.mEvent =
        new AiSuggestionEvent(this, cardId, formItem, this.isOuterDesktop, this.isDuringAppExitAnimFunction);
    }
  }

  public setCardId(cardId: string): void {
    this.cardId = cardId;
  }

  public updateDesc2TopMargin(desc2TopMargin: number): void {
    this.viewData.desc2TopMargin = desc2TopMargin;
  }

  public updateCurColorMode(curColorMode: ConfigurationConstant.ColorMode): void {
    this.curColorMode = curColorMode;
  }

  public getViewData(): AiSuggestionComponentData {
    return this.viewData;
  }

  public setDuringAppExitAnim(isDuringAppExitAnim: boolean): void {
    this.mIsDuringAppExitAnim = isDuringAppExitAnim;
  }

  public isDuringAppExitAnim(): boolean {
    return this.mIsDuringAppExitAnim;
  }

  public setArriveTime(isArriveTime: boolean): void {
    this.viewData.isArrivedTime = isArriveTime;
  }

  public initCard(isCreatingCard?: boolean): void {
    if (!AppStorage.get<boolean>('isClearInvalidCardsDone')) {
      log.showWarn('clearInvalidCards is not complete');
      return;
    }
    // 在卡片创建的过程中如果是拖拽落位创建或者是点击按钮新建的
    let newCreatedFormId: string | undefined = AppStorage.get('createFormId');
    this.isNewAddedComponent =
      CheckEmptyUtils.checkStrIsEmpty(newCreatedFormId) && newCreatedFormId === this.cardId;
    if (AbilityFormUtil.isCardIdInvalid(this.cardId)) {
      this.checkUseDefaultCard();
      return;
    }
    let cardInfo = AiSuggestionFormManager.getInstance().getCardInfo(this.cardId);
    if (cardInfo) {
      log.showInfo(`initData ${this.cardId}, isOuterDesktop: ${this.isOuterDesktop}`);
      this.updateCard(cardInfo);
      return;
    }

    let extraData = ExtraData.getExtendData(this.formItem);
    if (extraData && AbilityFormUtil.isAddPortfolioCardToFormStack(extraData)) {
      // 堆叠场景卡
      this.updatePortfolioCard(extraData);
      return;
    }
    AiSuggestionFormManager.getInstance().initVoiceCardInfo(this.formItem, isCreatingCard);
  }

  private updatePortfolioCard(extraData: ExtraData) {
    log.showInfo('updatePortfolioCard cardId: %{public}s', this.cardId);

    // 堆叠创建时，从缓存获取场景卡刷新
    // 重启时数据库中获取的commandType不符合预期会异常走这个分支，而缓存中没有数据，会导致卡片显示空白，因此增加else分支处理此异常情况
    let launcherCardInfo = OperateFormStackHelper.getInstance().getCachePortfolioCardInfo(this.cardId ?? '');
    if (launcherCardInfo) {
      log.showInfo(`updateCardInfo cardId=${this.cardId}`);
      AiSuggestionFormManager.getInstance().updateCardInfo(this.cardId, launcherCardInfo);
    } else {
      log.showInfo(`updatePortfolioCard cardId=${this.cardId}, launcherCardInfo invalid`);
      AiSuggestionFormManager.getInstance().initVoiceCardInfo(this.formItem);
    }

    OperateFormStackHelper.getInstance().onPortfolioCardAddToFormStack(extraData);
    let cardItemInfo = this.formItem as Object as CardItemInfo;
    ExtraData.resetExtend1AfterAddSuccess(cardItemInfo);
    log.showInfo(`updatePortfolioCard reset cardId=${this.cardId}, extend1=${cardItemInfo.extend1}`);
    FormModel.getInstance().updateExtend1ByCardId(cardItemInfo.extend1, this.cardId);
  }

  private checkUseDefaultCard() {
    if (this.viewData.recItems.length === 0 && CheckEmptyUtils.isEmpty(this.viewData.portfolioInfo?.agentInfo)) {
      // 推荐列表为空，添加语音助手建议引导卡片
      this.useDefaultCard();
    }
  }

  public isNewAddComponent(): boolean {
    return this.isNewAddedComponent;
  }

  /**
   * 删除卡片
   *
   * @param cardId 卡片id
   */
  public deleteCard(cardId: string): void {
    log.showInfo(`deleteCard cardId: ${cardId}`);
    try {
      LauncherAnimUtil.setIsUIBusy(TAG, true);
      this.deleteForm?.(true);
      // 桌面/堆叠卡片删除动效500ms，去除标记时间需要保证缓存中的数据已经被清除，取700ms
      setTimeout(() => {
        LauncherAnimUtil.setIsUIBusy(TAG, false);
      }, 700);
    } catch (err) {
      LauncherAnimUtil.setIsUIBusy(TAG, false);
      log.showError(`onDelete error ${err}`);
    }
  }

  /**
   * 重置卡片
   */
  public resetCard(): void {
    this.updateCard(undefined);
  }

  /**
   * 更新卡片
   *
   * @param cardInfo 卡片内容
   */
  public updateCard(cardInfo: LauncherCardInfo | undefined): void {
    log.showInfo(`updateCard cardId: ${this.cardId}`);
    if (!AppStorage.get<boolean>('isClearInvalidCardsDone')) {
      log.showWarn('updateCardInfo clearInvalidCards is not complete');
      return;
    }
    const launcherDisplayCardInfo: LauncherDisplayCardInfo | undefined = LauncherCardInfo.getDisplayCardInfo(cardInfo);

    // 5.0升级上来还未走刷新从数据库取的老版本的间距参数为空, 赋默认值
    if (launcherDisplayCardInfo) {
      launcherDisplayCardInfo.headerHeight =
        (!launcherDisplayCardInfo.headerHeight || Number.isNaN(launcherDisplayCardInfo.headerHeight)) ? 28 :
        launcherDisplayCardInfo.headerHeight;
      launcherDisplayCardInfo.columnGap =
        (!launcherDisplayCardInfo.columnGap || Number.isNaN(launcherDisplayCardInfo.columnGap)) ? 8 :
        launcherDisplayCardInfo.columnGap;
      launcherDisplayCardInfo.rowGap =
        (!launcherDisplayCardInfo.rowGap || Number.isNaN(launcherDisplayCardInfo.rowGap)) ? 8 :
        launcherDisplayCardInfo.rowGap;
      launcherDisplayCardInfo.gridPadding =
        (!launcherDisplayCardInfo.gridPadding || Number.isNaN(launcherDisplayCardInfo.gridPadding)) ? 8 :
        launcherDisplayCardInfo.gridPadding;
      log.showInfo(`convertDisplayData headerHeight:${launcherDisplayCardInfo.headerHeight}, columnGap:${launcherDisplayCardInfo.columnGap}, rowGap:${launcherDisplayCardInfo.rowGap}, gridPadding:${launcherDisplayCardInfo.gridPadding}`);
    }
    const portfolioInfo = cardInfo?.portfolioInfo;
    if (!launcherDisplayCardInfo ||
    LauncherCardInfo.isCardInfoInValid(launcherDisplayCardInfo, portfolioInfo?.agentInfo)) {
      // 调用onUpdate(null)来重置卡片，应该立即重置卡片
      this.useDefaultCard();
      this.updateAppName?.(ResUtils.getInnerString($r('app.string.aisuggestion_app_name')));
      return;
    }
    const newRecItems: LauncherRecItem[] = this.getNewRecItems(launcherDisplayCardInfo);
    let oldRecItems: LauncherRecItem[] = ObjectCopyUtil.deepClone(this.viewData.recItems);
    const changedItemRecord = AiSuggestionDataProcess.updateChangedItemRecord(oldRecItems, newRecItems);
    this.changedItemIdsSet = changedItemRecord.diffIdSet as Set<string>;
    this.disappearLastIndex = changedItemRecord.disappearLastIndex as number;
    if (!CheckEmptyUtils.isEmptyArr(oldRecItems) && !CheckEmptyUtils.isEmptyArr(newRecItems) &&
      this.changedItemIdsSet.size === 0) {
      log.showInfo(`cardId=${this.cardId} updateCardInfo no changedItem`);

      // 如果场景卡前后二次刷新的数据一致则不做场景栏3s可见的动效
      if (portfolioInfo && portfolioInfo.displayMode === PortfolioInfoDisplayMode.DISPLAY_MODE_DISAPPEAR) {
        portfolioInfo.displayMode = PortfolioInfoDisplayMode.DISPLAY_MODE_NOT_EXIST;
      }
    }
    this.viewData.portfolioInfo = portfolioInfo;
    this.viewData.launcherDisplayCardInfo = launcherDisplayCardInfo;
    this.viewData.cardResourceInfo = this.getPortfolioRes(this.curColorMode, portfolioInfo);

    this.layoutStyle?.update(launcherDisplayCardInfo, portfolioInfo, this.isOuterDesktop);
    this.updatePortfolioInfo(portfolioInfo);
    this.updateCardStatus(newRecItems, launcherDisplayCardInfo);
    if (this.isEmptyBgColor() && !SCBVisualEffectMgr.isFolderSolidColor()) {
      // 如果是全应用版式但是是纯色模式不使用useEffect
      this.isUseEffect?.(true);
      this.viewData.isUseEffectValue = true;
      this.viewData.mUseEffect = !this.isFormStackChildItem;
    } else {
      this.isUseEffect?.(false);
      this.viewData.isUseEffectValue = false;
      this.viewData.mUseEffect = false;
    }
    this.updateCardSuccess?.();
    AiSuggestionDataHelper.logDisplayCardInfo(this.formItem, launcherDisplayCardInfo, cardInfo?.portfolioInfo);
  }

  public isEmptyBgColor(): boolean {
    if (this.viewData.cardResourceInfo?.bgStartClr || this.viewData.cardResourceInfo?.bgMidClr ||
      this.viewData.cardResourceInfo?.bgEndClr ||
      this.viewData.cardResourceInfo?.fgStartClr || this.isHideRadialGradient()) {
      return false;
    }
    return true;
  }

  public isHideRadialGradient(): boolean {
    // 普通卡displayMode为undefined
    if (CheckEmptyUtils.isEmpty(this.viewData.portfolioInfo?.displayMode)) {
      return this.viewData.gridPadding === 0;
    }
    return this.viewData.gridPadding === 0 &&
      this.viewData.portfolioInfo?.displayMode === PortfolioInfoDisplayMode.DISPLAY_MODE_NOT_EXIST;
  }

  private setSolidBgColor(): void {
    if (this.isEmptyBgColor() && SCBVisualEffectMgr.isFolderSolidColor()) {
      if (this.isFormStackChildItem) {
        this.viewData.backgroundColor =
          this.curColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ? '#373A3D' : '#DCDEE5';
      } else {
        this.viewData.backgroundColor =
          this.curColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ? '#802E3033' : '#99FAFAFA';
      }
    } else {
      this.viewData.backgroundColor = '';
    }
  }

  /**
   * 长按类型变化
   *
   * @param longPressType 长按类型
   */
  public onLongPressTypeChange(longPressType: LongPressType): void {
    this.viewData.formPressType = longPressType;
    if (longPressType === LongPressType.GET_WALLPAPER) {
      this.getCropWallPaperPixelMap?.();
    }
  }

  private updateCardStatus(newRecItems: LauncherRecItem[], displayCardInfo: LauncherDisplayCardInfo): void {
    if (!sSCBOobeManager.isOobeActivated()) {
      this.viewData.recItemCompId = undefined;
    }
    // 赋值给recItems前先排序，在数组中的位置有变化也会触发GridItem下的节点重建
    newRecItems.sort((a: LauncherRecItem, b: LauncherRecItem): number => {
      if (a.rowStart === b.rowStart) {
        return a.columnStart - b.columnStart;
      }
      return a.rowStart - b.rowStart;
    });
    this.viewData.recItems = newRecItems;
    AbilityFormUtil.setStorageForCompanion(this.cardId, this.viewData.recItems);

    // 如果是单个FA就不加边距
    this.viewData.gridPadding =
      AbilityFormUtil.isFullFill(this.viewData.recItems) ? 0 : this.viewData.launcherDisplayCardInfo.gridPadding;

    this.refreshIconStyle(displayCardInfo, newRecItems);

    this.viewData.descPadding = this.layoutStyle?.getDescPadding();
    this.viewData.chipItemMargin = this.layoutStyle?.getChipItemMargin();

    newRecItems.forEach(recItem => {
      if (recItem.itemType === AiSuggestionConstants.TYPE_APP_GROUP) {
        AiSuggestionAppGroupManager.getInstance().updateSubItems(this.formItem, recItem);
      }
    });
  }

  private updatePortfolioInfo(portfolioInfo: PortfolioInfo | undefined): void {
    this.updateLanguage(portfolioInfo);
    this.updateColorMode(portfolioInfo);
    this.viewData.isArrivedTime = false;
    this.viewData.updateAppNameValue = this.getAppName();
    this.updateAppName?.(this.viewData.updateAppNameValue);
    log.showInfo(`updatePortfolioInfo cardId: ${this.formItem?.cardId}, portfolioName: ${portfolioInfo?.name}`);
    if (portfolioInfo?.displayMode === PortfolioInfoDisplayMode.DISPLAY_MODE_DISAPPEAR) {
      this.mEvent?.registerAlarm();
    }
  }

  public updateLanguage(portfolioInfo: PortfolioInfo | undefined): void {
    const currentLanguage = LanguageUtil.getCurrentLanguage();
    if (portfolioInfo && portfolioInfo.multiLanguages) {
      portfolioInfo.name = portfolioInfo.multiLanguages.name?.[currentLanguage] ??
        portfolioInfo.multiLanguages.name?.[LanguageUtil.DEFAULT_LANGUAGE] ?? '';
      portfolioInfo.desc = portfolioInfo.multiLanguages.desc?.[currentLanguage] ??
        portfolioInfo.multiLanguages.desc?.[LanguageUtil.DEFAULT_LANGUAGE] ?? '';
      portfolioInfo.desc1 = portfolioInfo.multiLanguages.desc1?.[currentLanguage] ??
        portfolioInfo.multiLanguages.desc1?.[LanguageUtil.DEFAULT_LANGUAGE] ?? '';
      portfolioInfo.desc2 = portfolioInfo.multiLanguages.desc2?.[currentLanguage] ??
        portfolioInfo.multiLanguages.desc2?.[LanguageUtil.DEFAULT_LANGUAGE] ?? '';
      log.showInfo('cardId: %{public}s, portfolioId: %{public}s, currentLanguage: %{public}s, name: %{public}s, desc: %{public}s, desc1: %{public}s, desc2: %{public}s',
        this.cardId, portfolioInfo.portfolioId, currentLanguage, portfolioInfo.name, portfolioInfo.desc,
        portfolioInfo.desc1, portfolioInfo.desc2);
    }
  }

  public getChangeItemIds(): Set<string> {
    return this.changedItemIdsSet;
  }

  public getDisappearLastIndex(): number {
    return this.disappearLastIndex;
  }

  private useDefaultCard() {
    ExtraData.resetData(this.formItem);
    if (AbilityFormUtil.isCardIdInvalid(this.cardId)) {
      // cardId无效时注册不了刷新回调,因此须在当前组件初始化默认卡片
      let rectFaItem: LauncherRecItem = AiSuggestionDataHelper.getDefaultCard(this.formItem);
      log.showInfo(`useDefaultCard ${typeof rectFaItem.cardId}, ${JSON.stringify(rectFaItem)}`);
      this.viewData.recItems = [rectFaItem];
      this.viewData.recItemCompId = undefined;
      this.viewData.recItemCardsVisibility.clear();
      AbilityFormUtil.setStorageForCompanion(this.cardId, this.viewData.recItems);
      this.viewData.launcherDisplayCardInfo.rowsTemplate = Array(this.formItem.cardDimension).fill('1fr').join(' ');
      this.viewData.launcherDisplayCardInfo.columnsTemplate = Array(this.formItem.cardDimension).fill('1fr').join(' ');
      this.viewData.gridPadding = 0; // 如果是单个FA就不加边距
    } else {
      // 显示默认卡片时重置语音助手建议卡片可以复用卡片ID
      AiSuggestionFormManager.getInstance().showDefaultCard(this.formItem);
    }
    this.viewData.portfolioInfo = undefined;
    this.viewData.cardResourceInfo = new CardResourceInfo();
  }

  public refreshIconStyle(displayCardInfo: LauncherDisplayCardInfo, recItems: LauncherRecItem[]): void {
    const pageDesktopStyleConfig: PageDesktopGridStyleConfig =
      PageDesktopModel.getInstance().getPageDesktopStyleConfig();
    let desktopIconRadius = 0;
    let desktopIconSize = 0;
    desktopIconSize = pageDesktopStyleConfig.mIconSize;
    desktopIconRadius = pageDesktopStyleConfig.mIconRadius;
    let calcWidth = desktopIconSize;
    const appGroupLength = recItems.filter(item => item.itemType === AiSuggestionConstants.TYPE_APP_GROUP).length;
    let formWidth = this.viewData.formItemWidth;
    if (AbilityFormUtil.is2x2Form(this.formItem) &&
      this.viewData.formItemWidth !== this.viewData.formItemHeight) {
      formWidth = Math.min(this.viewData.formItemWidth, this.viewData.formItemHeight);
    }

    const formColumn = displayCardInfo.column ?? AiSuggestionConstants.DEFAULT_SCENE_SPAN;
    // 2x2卡片或者非应用组版式
    if (AbilityFormUtil.is2x2Form(this.formItem) || appGroupLength === 0) {
      calcWidth = (formWidth - ((formColumn - 1) * displayCardInfo.columnGap) -
        (2 * displayCardInfo.gridPadding)) / formColumn;
    } else {
      // 2x2卡片&4x4卡片 (calcWidth = 母卡片的宽度/2 - gridPadding - 0.5*gap - 4 * 5vp) / 3
      calcWidth = ((formWidth / 2) - displayCardInfo.gridPadding -
        (displayCardInfo.columnGap / 2) - 2 * AiSuggestionConstants.APP_GROUP_COLUMN_GAP -
        2 * displayCardInfo.gridPadding) / 3;
    }

    // 升级上来概率calcWidth首次为NaN, 需要重新给默认值
    if (Number.isNaN(calcWidth)) {
      log.showError('refreshIconStyle calcWidth is isNaN');
      this.viewData.iconSize = this.isEmptyBgColor() ? AiSuggestionConstants.ICON_DEFAULT_SIZE :
      AiSuggestionConstants.APP_GROUP_DEFAULT_ICON_SIZE;
    } else {
      this.viewData.iconSize = Math.min(calcWidth, desktopIconSize);
    }
    this.viewData.iconRadius = this.viewData.iconSize / desktopIconSize * desktopIconRadius;
    log.showInfo(`refreshIconStyle [${this.cardId}] formItemWidth:${this.viewData.formItemWidth},
     formItemHeight:${this.viewData.formItemHeight}, isOuterDesktop:${this.isOuterDesktop}
     desktopIconRadius:${desktopIconRadius}, desktopIconSize:${desktopIconSize}, iconSize:
     ${this.viewData.iconSize}, iconRadius:${this.viewData.iconRadius}`);
    this.updateSubFormSizeIfNeed();
  }

  public updateSubFormSizeIfNeed(): void {
    this.viewData.isFormSizeChange = !this.viewData.isFormSizeChange
  }

  private getPortfolioRes(curColorMode: ConfigurationConstant.ColorMode,
    portfolioInfo: PortfolioInfo | undefined): CardResourceInfo {
    let portfolioRes = portfolioInfo?.light;
    if (portfolioInfo && curColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      portfolioRes = portfolioInfo.dark ?? portfolioInfo.light;
    }
    this.setSolidBgColor();
    return portfolioRes ?? new CardResourceInfo();
  }

  public async updateColorMode(portfolioInfo: PortfolioInfo | undefined): Promise<void> {
    if (portfolioInfo?.portfolioId) {
      this.viewData.cardResourceInfo =
        AiSuggestionDataHelper.getPortfolioRes(this.curColorMode, portfolioInfo) ?? new CardResourceInfo();
      this.viewData.portfolioPicUrl =
        await AiSuggestionDataHelper.getPortfolioPic((this.viewData.cardResourceInfo?.picResId ??
          this.viewData.cardResourceInfo?.pic1ResId) as string);
    }
    this.viewData.appGroupBgColor =
      AiSuggestionDataHelper.getAppGroupBgColor(this.curColorMode, portfolioInfo);
    log.showInfo(`updateColorMode cardId: ${this.formItem.cardId}, curColorMode: ${this.curColorMode}`);
    this.setSolidBgColor();
  }

  public unRegisterEvent(): void {
    log.showInfo(`unRegisterEvent cardId: ${this.formItem.cardId}`);
    this.mEvent?.unRegisterEvent();
  }

  public getAppName(): string {
    let cardName: string = ResUtils.getInnerString($r('app.string.aisuggestion_app_name'));
    if (this.viewData.portfolioInfo && PortfolioInfo.isPortfolioCard(this.viewData.portfolioInfo.portfolioId) &&
    this.viewData.portfolioInfo.name) {
      cardName = this.viewData.portfolioInfo.name;
    }
    log.showError(`getAppName cardId: ${this.formItem.cardId}, cardName: ${cardName}`);
    return cardName;
  }

  /**
   * 获取新的推荐列表
   *
   * @param displayCardInfo 卡片信息
   * @returns 推荐列表
   */
  private getNewRecItems(displayCardInfo: LauncherDisplayCardInfo | undefined): LauncherRecItem[] {
    if (!displayCardInfo || CheckEmptyUtils.isEmptyArr(displayCardInfo.recItems)) {
      log.showError('getNewRecItem displayCardInfo invalid or recItems empty');
      return [];
    }
    log.showInfo(`getNewRecItem displayCardInfo recItems length = ${displayCardInfo.recItems.length}`);

    // 过滤掉不合法的数据，如空对象{}
    let newRecItems: LauncherRecItem[] = displayCardInfo.recItems.filter((item: LauncherRecItem) => {
      return LauncherRecItem.isValid(item);
    }) ?? [];
    if (CheckEmptyUtils.isEmptyArr(newRecItems)) {
      // 数据源不为空，过滤后为空，打印过滤前的数据集合
      const recItemContent: string[] = displayCardInfo.recItems.filter(Boolean).map(item => {
        return [item.itemType, item.rowStart, item.columnStart, item.rowSpan, item.columnSpan].join('_');
      });
      log.showError(`getNewRecItem occur error, recItems empty, recItems = ${recItemContent.toString()}`);
      return [];
    }
    return newRecItems;
  }
}