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
  ViewType,
  ViewManagerPolicy,
  DeviceHelper,
  viewMgrPolicy,
  GlobalContext,
} from '@ohos/frameworkwrapper';
import { 
  AppItemInfo, 
  CardItemInfo, 
  CommonConstants, 
  editModeManager,
  FormModel,
  GridLayoutUtil,
  FormManager,
  GridLayoutItemInfo,
} from '@ohos/launchercommon';
import lazy { OuterAppManager } from '@ohos/launchercommon/src/main/ets/manager/OuterAppManager';
import {
  FormCenterViewParam,
  FormDisplayType,
} from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { launcherStatusUtil, SCBSceneContainerSession, SCBSceneSessionManager } from '@ohos/windowscene';
import { MultimodalInputManager } from '@ohos/systemuicommon';
import systemParameter from '@ohos.systemparameter';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import { FormViewModel } from '../../default/viewmodel/FormViewModel';
import ServiceFormManager from '../../default/manager/ServiceFormManager';
import FormStyleConstants from '../../default/common/constants/FormStyleConstants';
import { FormCenterViewData } from '../../default/viewmodel/FormCenterViewData';
import { FormCenterLocation } from '../viewstyles/manager/FormCenterEnum';
import { FormUtil } from '../../default/util/FormUtil';
import { SearchStateMgr } from '../view/atomicview/SearchComponent';

const TAG: string = 'FormCenterViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
const SCREEN_LOCK_FORM_WHITE_LIST_1X1: string[] =
  ['com.ohos.totemweather', 'com.ohos.clock',
    'com.ohos.calculator', 'com.ohos.health', 'com.ohos.musicservice'];
const SCREEN_LOCK_FORM_WHITE_LIST_1X2: string[] =
  ['com.ohos.totemweather', 'com.ohos.health'];
const PC_MODE_FILTER_FORM_LIST: string[] =
  ['com.ohos.systemmanagerform', 'com.ohos.suggestion', 'com.ohos.sceneboard'];

const VARIETY_CARDS_OUTER_HOME_SUPPORT_PARAM: string = 'const.sceneboard.card.outer_home_support_variety_card';
export enum CloseReason {
  CLOSE_BY_ADD_FORM = 0,
  CLOSE_BY_BACK,
  OTHER,
  CLOSE_BY_TO_THEME,
}

export class FormCenterViewModel {
  public customGridWidth: number = 0; // 自定义网格宽度
  private static mInstance: FormCenterViewModel;
  private appInfoList: AppItemInfo[] = [];
  private recommendedCardList: CardItemInfo[] = [];
  private formDimensionSpan: Map<number, number> = new Map();
  private cardListPool: CardItemInfo[] = [];
  private isHideWindows: boolean = false;
  // 关闭按钮点击事件
  private isCardExceedLimit: boolean = false;
  private closeReason: CloseReason = CloseReason.OTHER;
  private isSupportDrag: boolean = true;
  private isSupportCreateAnimate: boolean = true;
  private _isScreenLock: boolean = false;
  private formCenterLocation: FormCenterLocation = FormCenterLocation.DESKTOP;
  private _isCurrentSuggestion: boolean = false;
  private _isNegativeScreenOpen: boolean = false;
  private _isAsdeOpen: boolean = false;
  private negativeScreenSupportDimensions: number[] = [];
  private negativeScreenBundleBlackList: string[] = [];
  private isNegativeScreenSupportAddCard: boolean = false;
  // 外屏显示主题百变卡片开关
  private isOutHomeSupportVarietyCard: boolean =
    systemParameter.getSync(VARIETY_CARDS_OUTER_HOME_SUPPORT_PARAM, 'true') === 'true';
  private shouldDisableNegativeAddCard: boolean = false; // 是否需要置灰添加到负一屏按钮

  public setNegativeSupportDimension(dimensions: number[]) {
    log.showInfo(`setNegativeSupportDimension dimensions: ${dimensions}`);
    this.negativeScreenSupportDimensions = dimensions;
  }

  public setShouldDisableNegativeAddCard(disableNegativeBtn: boolean) {
    log.showInfo(`setShouldDisableNegativeAddCard disableNegativeBtn: ${disableNegativeBtn}`);
    this.shouldDisableNegativeAddCard = disableNegativeBtn;
  }

  public setNegativeBundleNameBlackList(blackList: string[]) {
    log.showInfo(`setNegativeSupportDimension dimensions: ${blackList}`);
    this.negativeScreenBundleBlackList = blackList;
  }

  public setNegativeAddCardStatus(status: boolean) {
    log.showInfo(`setNegativeAddCardStatus status: ${status}`);
    this.isNegativeScreenSupportAddCard = status;
  }

  public isDisableButtonForNegativeScreen(dimension: number, bundleName: string): boolean {
    if (this.shouldDisableNegativeAddCard) {
      log.showError(`isDisableButtonForNegativeScreen, disable: ${this.shouldDisableNegativeAddCard}`);
      return false;
    }
    // 卡片尺寸白名单校验
    if (!this.negativeScreenSupportDimensions.includes(dimension)) {
      log.showError(`isDisableButtonForNegativeScreen, ${dimension} is not support my card.`);
      return false;
    }

    // 卡片包名黑名单校验
    if (this.negativeScreenBundleBlackList.includes(bundleName)) {
      log.showError(`isDisableButtonForNegativeScreen, ${bundleName} is not support my card.`);
      return false;
    }

    return true;
  }

  public getNegativeScreenBundleBlackList(): string[] {
    return this.negativeScreenBundleBlackList;
  }

  public getNegativeAddCardStatus(): boolean {
    log.showInfo(`getNegativeAddCardStatus status: ${this.isNegativeScreenSupportAddCard}`);
    return this.isNegativeScreenSupportAddCard;
  }

  public isShowButtonByAsdeForNegativeScreen(): boolean {
    return this.isAsdeOpen && this.getNegativeAddCardStatus() && !launcherStatusUtil.getShowOutLauncherStatus();
  }

  public isShowButtonByNegativeScreenOpen(): boolean {
    return this._isNegativeScreenOpen && this.getNegativeAddCardStatus();
  }

  public set isCurrentSuggestion(value: boolean) {
    log.showInfo(`set is suggestion: ${value}`);
    this._isCurrentSuggestion = value;
  }

  public get isCurrentSuggestion(): boolean {
    return this._isCurrentSuggestion;
  }

  public updateFormCenterLocation(param: FormCenterViewParam): void {
    if (param.formDisplayType === FormDisplayType.SCREEN_LOCK_CARD) {
      this.formCenterLocation = FormCenterLocation.SCREEN_LOCK;
      return;
    }

    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      this.formCenterLocation = FormCenterLocation.OUTER;
      return;
    }
    const isLandscape: boolean = FormUtil.isPlateLandscape();
    if (isLandscape) {
      this.formCenterLocation = FormCenterLocation.LANDSCAPE;
      return;
    }

    this.formCenterLocation = FormCenterLocation.DESKTOP;
  }

  public getFormCenterLocation(): FormCenterLocation {
    return this.formCenterLocation;
  }

  public set isScreenLock(value: boolean) {
    this._isScreenLock = value;
  }

  public get isScreenLock(): boolean {
    return this._isScreenLock;
  }

  public set isNegativeScreenOpen(value: boolean) {
    this._isNegativeScreenOpen = value;
  }

  public get isNegativeScreenOpen(): boolean {
    return this._isNegativeScreenOpen;
  }

  public set isAsdeOpen(value: boolean) {
    this._isAsdeOpen = value;
  }

  public get isAsdeOpen(): boolean {
    return this._isAsdeOpen;
  }

  public setIsSupportCreateAnimate(isSupportCreateAnimate: boolean) {
    log.showWarn(`set isSupportCreateAnimate: ${isSupportCreateAnimate}`);

    this.isSupportCreateAnimate = isSupportCreateAnimate;
  }

  public getIsSupportCreateAnimate(): boolean {
    log.showWarn(`get closeReason: ${this.isSupportCreateAnimate}`);
    return this.isSupportCreateAnimate;
  }

  private constructor() {
    this.dimensionSpanMapInit();
  }

  public static getInstance(): FormCenterViewModel {
    if (FormCenterViewModel.mInstance == null) {
      FormCenterViewModel.mInstance = new FormCenterViewModel();
    }
    return FormCenterViewModel.mInstance;
  }

  public setCloseReason(closeReason: CloseReason): void {
    log.showWarn(`set closeReason: ${closeReason}`);
    this.closeReason = closeReason;
  }

  public getCloseReason(): CloseReason {
    log.showWarn(`get closeReason: ${this.closeReason}`);
    return this.closeReason;
  }

  public setIsSupportDrag(isSupportDrag: boolean): void {
    log.showWarn(`set closeReason: ${isSupportDrag}`);
    this.isSupportDrag = isSupportDrag;
  }

  public getIsSupportDrag(): boolean {
    log.showWarn(`get isSupportDrag: ${this.isSupportDrag}`);
    return this.isSupportDrag;
  }

  public getIsIsCardExceedLimit(): boolean {
    log.showWarn(`get isCloseByAddForm: ${this.isCardExceedLimit}`);
    return this.isCardExceedLimit;
  }

  public updateIsCardExceedLimit(): void {
    let isCardExceedLimit: boolean = FormModel.getInstance().checkIfCardExceedLimit();
    log.showWarn(`set isCardExceedLimit: ${isCardExceedLimit}`);
    this.isCardExceedLimit = isCardExceedLimit;
  }

  private dimensionSpanMapInit(): void {
    this.formDimensionSpan.set(CommonConstants.CARD_DIMENSION_1x1, 1);
    this.formDimensionSpan.set(CommonConstants.CARD_DIMENSION_1x2, 2);
    this.formDimensionSpan.set(CommonConstants.CARD_DIMENSION_2x2, 2);
    this.formDimensionSpan.set(CommonConstants.CARD_DIMENSION_2x4, 4);
    this.formDimensionSpan.set(CommonConstants.CARD_DIMENSION_4x4, 4);
    this.formDimensionSpan.set(CommonConstants.CARD_DIMENSION_6x4, 4);
  }

  public getCardSpan(dimension: number): number {
    let res: number = Number(this.formDimensionSpan.get(dimension));
    if (Number.isNaN(res)) {
      return 0;
    }
    return res;
  }

  public getAppInfo(bundleName: string): AppItemInfo {
    return this.appInfoList.find(item => item.bundleName === bundleName) as AppItemInfo;
  }

  public getAppList(): AppItemInfo[] {
    return this.appInfoList;
  }

  private filterFormAppInfos(formAppInfos: AppItemInfo[]): void {
    let formModel: FormModel = FormModel.getInstance();
    this.cardListPool = [];
    formAppInfos.forEach((formAppInfo) => {
      let appFormList: CardItemInfo[] | undefined =
        formModel.getAppItemFormInfo(formAppInfo.bundleName, (item: CardItemInfo) => formModel.isScreenLockSupportCard(item));
      if (!appFormList) {
        return;
      }
      this.cardListPool.push(...appFormList);
    })
    log.showWarn(`after filter screenLock forms num: ${this.cardListPool.length}`);
    return;
  }

  public isPcModeSupportCard(formInfo: CardItemInfo): boolean {
    return FormModel.getInstance().isFormCenterSupportCard(formInfo) &&
      !PC_MODE_FILTER_FORM_LIST.includes(formInfo.bundleName);
  }

  public async updateFromManagerData(isScreenLock: boolean): Promise<void> {
    // 从包管理获取app
    this.appInfoList = [];
    let formModel: FormModel = FormModel.getInstance();
    if (formModel.isSupportFormCenterSplit()) {
      let suggestionItem: AppItemInfo = new AppItemInfo();
      suggestionItem.bundleName = FormStyleConstants.FORM_CENTER_DEFAULT_ITEM;
      this.appInfoList.push(suggestionItem);
    }

    // 获取app列表
    let appList: AppItemInfo[] = [];
    if (isScreenLock) {
      appList = await formModel.getFormCenterAppList((item: CardItemInfo) => formModel.isScreenLockSupportCard(item));
    } else if (DeviceHelper.is2In1DevicePcType()) {
      appList = await formModel.getFormCenterAppList((item: CardItemInfo) => this.isPcModeSupportCard(item));
    } else {
      appList = await formModel.getFormCenterAppList((item: CardItemInfo) => formModel.isFormCenterSupportCard(item));
    }

    if (isScreenLock) {
      this.filterFormAppInfos(appList);
    }
    this.appInfoList.push(...appList);
    log.showWarn(`apps num: ${this.appInfoList.length}`);
    // 外屏卡片过滤
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      this.appInfoList = this.appInfoList.filter(appItemInfo => {
        return !OuterAppManager.getInstance().isFilterCard(appItemInfo.bundleName, true);
      });
    }
  }

  public async updateFromCenterData(isScreenLock?: boolean): Promise<void> {
    isScreenLock = isScreenLock ?? this._isScreenLock;
    // 从包管理获取app
    await this.updateFromManagerData(isScreenLock);
  }

  /**
   * Get form display size.
   *
   * @param dimension form dimension
   * @param isWidth is width or height
   * @returns display size
   */
  public getFormDisplaySize(dimension: number, isWidth: boolean): number {
    let formSize = 0;
    if (dimension === undefined || dimension === null) {
      return formSize;
    }

    if (isWidth) {
      formSize = FormViewModel.getInstance().getFormStyleConfig().mFormWidth.get(String(dimension)) as number;
    } else {
      formSize = FormViewModel.getInstance().getFormStyleConfig().mFormHeight.get(String(dimension)) as number;
    }
    formSize = GridLayoutUtil.getFloorVp(formSize);
    return formSize * FormCenterViewData.getInstance().getFormDimensionScale(dimension);
  }

  public getAppFormsIndexWhenSearch(formList: CardItemInfo[]): number {
    let searchedCardName: string | undefined =
      SearchStateMgr.getInstance().parsedSearchResult.get(formList[0].bundleName)?.descriptionMap.keys().next()?.value;
    if (!searchedCardName) {
      log.showInfo('searchedCardName is empty');
      return 0;
    }
    let index: number = formList.findIndex((item: CardItemInfo) => {
      return item.cardName === searchedCardName;
    })
    return index === -1 ? 0 : index;
  }

  /**
   * Get current form index
   */
  public getAppFormsIndex(startFormItem: CardItemInfo, formItem: CardItemInfo[]): number {
    if (CheckEmptyUtils.isEmptyArr(formItem)) {
      return 0;
    }

    // 搜索中，定位到匹配的第一个卡片
    if (SearchStateMgr.getInstance().getIsShowSearchResult()) {
      return this.getAppFormsIndexWhenSearch(formItem);
    }

    if (!CheckEmptyUtils.isEmpty(startFormItem)) {
      for (let i = 0; i < formItem.length; i++) {
        if (this.isFormItemMatch(startFormItem, formItem[i])) {
          log.showInfo(`getAppFormsIndex start ${i}, cardName: ${formItem[i].cardName}`);
          return i;
        }
      }
    }

    // 没传入卡片信息定位到默认卡片
    let isDefaultCardIndex: number = formItem.findIndex(i => i.isDefaultCardDimension === i.cardDimension);
    let defaultCardName: string = isDefaultCardIndex === -1 ? '' : formItem[isDefaultCardIndex].cardName;
    log.showInfo(`getAppFormsDefaultIndex ${isDefaultCardIndex}, defaultCardName: ${defaultCardName}`);
    return isDefaultCardIndex === -1 ? 0 : isDefaultCardIndex;
  }

  private isFormItemMatch(startFormItem: CardItemInfo, targetFormItem: CardItemInfo): boolean {
    return targetFormItem.bundleName === startFormItem.bundleName &&
      targetFormItem.abilityName === startFormItem.abilityName &&
      targetFormItem.moduleName === startFormItem.moduleName &&
      targetFormItem.cardName === startFormItem.cardName &&
      (!startFormItem.cardDimension || targetFormItem.cardDimension === startFormItem.cardDimension);
  }

  /**
   * 退出其他系统窗口,如应用中心,任务中心,dock,用于PC和PAD的自由多窗模式
   */
  public exitOtherSystemPanel(): void {
    if (!DeviceHelper.isPC() && !SCBSceneSessionManager.getInstance().isPcMode()) {
      return;
    }

    // 隐藏应用中心
    if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)) {
      log.showInfo('hide app center');
      viewMgrPolicy.hideView(ViewType.APP_CENTER);
    }

    // 隐藏任务中心
    if (AppStorage.get('showRecent') === true) {
      log.showInfo('hide recent');
      AppStorage.setOrCreate('showRecent', false);
    }

    log.showInfo('hideSmartDock');
    // 隐藏dock栏
    if (GlobalContext.getInstance().hasObject('hideDockViewWithAnimation')) {
      let hideDockViewWithAnimation = (GlobalContext.getInstance()
        .getObject('hideDockViewWithAnimation')) as Function;
      hideDockViewWithAnimation?.();
    } else {
      viewMgrPolicy.hideView(ViewType.SMART_DOCK);
    }
  }

  /**
   * 呼出dock栏,用于PC和PAD的自由多窗模式
   */
  public showSmartDock(): void {
    if (!DeviceHelper.isPC() && !SCBSceneSessionManager.getInstance().isPcMode()) {
      return;
    }
    log.showInfo('showSmartDock');
    // 呼出dock栏
    if (GlobalContext.getInstance().hasObject('showDockViewWithAnimation')) {
      let showDockViewWithAnimation = (GlobalContext.getInstance()
        .getObject('showDockViewWithAnimation')) as Function;
      showDockViewWithAnimation?.();
    } else {
      viewMgrPolicy.showView(ViewType.SMART_DOCK);
    }
  }

  /**
   * 处理PC设备独有业务逻辑
   */
  public dealPCShowFormCenter(): void {
    if (!DeviceHelper.isPC() && !SCBSceneSessionManager.getInstance().isPcMode()) {
      return;
    }
    // 判断PC是否存在前台窗口并最小化所有窗口
    if (!this.isHideWindows && SCBSceneSessionManager.getInstance().getContainerSessionList().filter((scene: SCBSceneContainerSession) => {
      return (scene.isActive && !scene.primarySession?.isMinimizing);
    })?.length > 0) {
      this.isHideWindows = true;
      if (AppStorage.get('toggleHomeShow') === true) {
        AppStorage.setOrCreate('toggleHomeShow', false);
      } else {
        AppStorage.setOrCreate('toggleHomeShow', true);
      }
    }
  }

  /**
   * 处理PC设备独有业务逻辑,恢复所有被卡片中心关闭的窗口
   */
  public recoveryAllWindows(): void {
    if (!DeviceHelper.isPC() && !SCBSceneSessionManager.getInstance().isPcMode() || !this.isHideWindows) {
      return;
    }
    this.isHideWindows = false;
    log.showWarn('recoveryAllWindows');
    if (MultimodalInputManager.dealWithShortcutKeyInFA) {
      MultimodalInputManager.dealWithShortcutKeyInFA = false;
      return;
    }
    if (AppStorage.get('toggleHomeShow') === true) {
      AppStorage.setOrCreate('toggleHomeShow', false);
    } else {
      AppStorage.setOrCreate('toggleHomeShow', true);
    }
  }

  /**
   * 拖拽撤销按钮显示
   */
  public dealUndoDragFormVisible(): void {
    let isNeedUndoDragProduct: boolean = DeviceHelper.isPhone() || DeviceHelper.isPad();
    if (isNeedUndoDragProduct) {
      AppStorage.setOrCreate('openFolderStatus', 0);
      AppStorage.setOrCreate<boolean>('undoDragFormVisible', true);
      ViewManagerPolicy.hideView(ViewType.STATUS_BAR);
    }
  }

  /**
   * 加载卡片中心功耗demo
   */
  private loadRecommendedCardDemoList(): void {
    try {
      let loadFormCenterDemoList: string = systemParameterEnhance.getSync("loadFormCenterDemoList", 'false');
      log.showInfo(`getSync loadFormCenterDemoList: ${loadFormCenterDemoList}`);
      if (loadFormCenterDemoList === 'true') {
        let recommendedCardDemoList: CardItemInfo[] = [];
        const bundleNames: string[] = ['com.example.recommendedCardDemo', 'com.example.recommendedCardDemo2', 'com.example.recommendedCardDemo3',
          'com.example.recommendedCardDemo4', 'com.example.recommendedCardDemo5'];
        for (const bundleName of bundleNames) {
          let recommendedCard: CardItemInfo = new CardItemInfo;
          recommendedCard.bundleName = bundleName;
          recommendedCard.abilityName = "EntryFormAbility";
          recommendedCard.moduleName = 'entry';
          recommendedCard.cardName = 'widget';
          recommendedCard.cardDimension = (bundleName === 'com.example.recommendedCardDemo') ? FormDimension.Dimension_2_4 : FormDimension.Dimension_2_2;
          recommendedCardDemoList.push(recommendedCard);
        }
        this.recommendedCardList = recommendedCardDemoList;
      }
    } catch(e) {
      log.showError(`getSync loadRecommendedCardDemoList failed code: ${e?.code}, msg: ${e?.message}`);
    }
  }
}
