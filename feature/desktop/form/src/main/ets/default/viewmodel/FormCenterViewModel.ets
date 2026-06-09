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
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  SingleBase,
  SingleContext,
  singleManager
} from '@ohos/basicutils';
import { ViewType, viewMgrPolicy, ViewManagerPolicy, DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { launcherStatusUtil, SCBSceneContainerSession, SCBSceneSessionManager } from '@ohos/windowscene';
import {
  AppItemInfo, 
  CardItemInfo, 
  CommonConstants,
  FormModel,
  EditModeConstants,
} from '@ohos/launchercommon';
import lazy { OuterAppManager } from '@ohos/launchercommon/src/main/ets/manager/OuterAppManager';
import { MultimodalInputManager } from '@ohos/systemuicommon';
import { FormViewModel } from './FormViewModel';
import ServiceFormManager from '../manager/ServiceFormManager';
import FormStyleConstants from '../common/constants/FormStyleConstants';
import { FormCenterViewData } from './FormCenterViewData';
import { EditModeSearchOptions } from '@ohos/launchercommon/src/main/ets/outerdesktop/viewmodel/EditModeSearchComponentEvent';
import lazy { EditSearchStateMgr, EditSearchShowState } from '@ohos/launchercommon/src/main/ets/outerdesktop/viewmodel/EditSearchComponentData';
import { SearchStateMgr } from '../view/SearchComponent';
import systemParameter from '@ohos.systemparameter';

const TAG: string = 'FormCenterViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
const SCREEN_LOCK_FORM_WHITE_LIST_1X1: string[] =
  ['com.ohos.totemweather', 'com.ohos.clock',
    'com.ohos.calculator', 'com.ohos.health', 'com.ohos.musicservice'];
const SCREEN_LOCK_FORM_WHITE_LIST_1X2: string[] =
  ['com.ohos.totemweather', 'com.ohos.health'];

const VARIETY_CARDS_OUTER_HOME_SUPPORT_PARAM: string = 'const.sceneboard.card.outer_home_support_variety_card';

export class FormCenterViewModel extends SingleBase {
  public static singleName: string = 'FormCenterViewModel';
  private static mInstance: FormCenterViewModel;
  private appInfoList: AppItemInfo[] = [];
  private formDimensionSpan: Map<number, number> = new Map();
  private cardListPool: CardItemInfo[] = [];
  private isHideWindows: boolean = false;
  private mEditSearchStateMgr: EditSearchStateMgr = EditSearchStateMgr.getInstance();
  private mSearchStateMgr: SearchStateMgr = SearchStateMgr.getInstance();
  // 关闭按钮点击事件
  private closeIconOnClick: () => void = () => {};
  private _isCurrentSuggestion: boolean = false;
  private negativeSupportDimensions: number[] = [];
  private negativeBundleNameBlackList: string[] = [];
  private isNegativeSupportAddCard: boolean = false;
  // 外屏显示主题百变卡片开关
  private isOutHomeSupportVarietyCard: boolean =
    systemParameter.getSync(VARIETY_CARDS_OUTER_HOME_SUPPORT_PARAM, 'true') === 'true';

  public setNegativeSupportDimension(dimensions: number[]) {
    log.showInfo(`setNegativeSupportDimension dimensions: ${dimensions}`);
    this.negativeSupportDimensions = dimensions;
  }

  public setNegativeBundleNameBlackList(blackList: string[]) {
    log.showInfo(`setNegativeSupportDimension dimensions: ${blackList}`);
    this.negativeBundleNameBlackList = blackList;
  }

  public setNegativeAddCardStatus(status: boolean) {
    log.showInfo(`setNegativeAddCardStatus status: ${status}`);
    this.isNegativeSupportAddCard = status;
  }

  public isDisableButtonForNegativeScreen(dimension: number, bundleName: string): boolean {
    // 卡片尺寸白名单校验
    if (!this.negativeSupportDimensions.includes(dimension)) {
      log.showError(`isDisableButtonForNegativeScreen, ${dimension} is not support my card.`);
      return false;
    }

    // 卡片包名黑名单校验
    if (this.negativeBundleNameBlackList.includes(bundleName)) {
      log.showError(`isDisableButtonForNegativeScreen, ${bundleName} is not support my card.`);
      return false;
    }

    return true;
  }

  public getNegativeAddCardStatus(): boolean {
    return this.isNegativeSupportAddCard;
  }

  public updateCurrentSuggestion(name: string) {
    let isSuggestion: boolean = name === FormStyleConstants.FORM_CENTER_DEFAULT_ITEM;
    log.showInfo(`set is suggestion: ${isSuggestion}, name: ${name}`);
    this._isCurrentSuggestion = isSuggestion;
  }

  public get isCurrentSuggestion(): boolean {
    return this._isCurrentSuggestion;
  }

  public pushPathByNameWithCache(formCenterPage: NavPathStack, name: string): void {
    this.updateCurrentSuggestion(name);
    let namesInStack: string[] = formCenterPage.getAllPathName() ?? [];
    if (namesInStack.includes(name)) {
      formCenterPage.moveToTop(name, false);
      // 缓存的最大长度为10
      if (namesInStack.length > 10) {
        formCenterPage.removeByIndexes([0]);
      }
    } else {
      formCenterPage.pushPathByName(name, null, false);
    }
  }

  constructor(ctx?: SingleContext) {
    super(ctx);
    this.dimensionSpanMapInit();
  }

  public static getInstance(ctx?: SingleContext): FormCenterViewModel {
    return singleManager.get<FormCenterViewModel>(FormCenterViewModel, ctx);
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
    formAppInfos.forEach((formAppInfo: AppItemInfo) => {
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


  public async updateFromManagerData(isScreenLock: boolean): Promise<void> {
    // 从包管理获取app
    this.appInfoList = [];
    let formModel: FormModel = FormModel.getInstance();

    // 获取app列表
    let appList: AppItemInfo[] = [];
    if (isScreenLock) {
      appList = await formModel.getFormCenterAppList((item: CardItemInfo) => formModel.isScreenLockSupportCard(item));
      this.filterFormAppInfos(appList);
    } else {
      appList = await formModel.getFormCenterAppList((item: CardItemInfo) => formModel.isFormCenterSupportCard(item));
    }
    this.appInfoList.push(...appList);
    log.showWarn(`apps num: ${this.appInfoList.length}`);
  }

  public async updateFromCenterData(isScreenLock: boolean): Promise<void> {
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
      formSize = FormViewModel.getInstance(this.singleContext).getFormStyleConfig().mFormWidth.get(String(dimension)) as number;
    } else {
      formSize = FormViewModel.getInstance(this.singleContext).getFormStyleConfig().mFormHeight.get(String(dimension)) as number;
    }
    return formSize * FormCenterViewData.getInstance().getFormDimensionScale(dimension);
  }

  /**
   * Get current form index
   */
  public getAppFormsIndex(startFormItem: CardItemInfo, formItem: CardItemInfo[]): number {
    if (CheckEmptyUtils.isEmpty(startFormItem) || CheckEmptyUtils.isEmptyArr(formItem)) {
      return 0;
    }

    for (let i = 0; i < formItem.length; i++) {
      if (this.isFormItemMatch(startFormItem, formItem[i])) {
        log.showInfo(`getAppFormsIndex start ${i}`);
        return i;
      }
    }
    return 0;
  }

  private isFormItemMatch(startFormItem: CardItemInfo, targetFormItem: CardItemInfo): boolean {
    return targetFormItem.bundleName === startFormItem.bundleName &&
      targetFormItem.abilityName === startFormItem.abilityName &&
      targetFormItem.moduleName === startFormItem.moduleName &&
      targetFormItem.cardName === startFormItem.cardName &&
      targetFormItem.cardDimension === startFormItem.cardDimension;
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
    let isPhoneOrPad: boolean = DeviceHelper.isPhone() || DeviceHelper.isPad();
    if (isPhoneOrPad) {
      AppStorage.setOrCreate('openFolderStatus', 0);
      AppStorage.setOrCreate<boolean>('undoDragFormVisible', true);
      ViewManagerPolicy.hideView(ViewType.STATUS_BAR);
    }
  }

  // 搜索按钮点击事件
  private searchIconOnClick = () => {
    log.showInfo('searchIconOnClick');
    this.mEditSearchStateMgr.setShowState(EditSearchShowState.SHOW);
    this.mSearchStateMgr.setIsShowSearchResult(true);
  }

  // 返回按钮点击事件
  private backIconOnClick = () => {
    log.showInfo('backIconOnClick');
    this.mEditSearchStateMgr.setShowState(EditSearchShowState.NOT_SHOW);
    GlobalContext.getContext()?.eventHub.emit(EditModeConstants.OUTER_RESET_SEARCH_DATA);
    this.mSearchStateMgr.setIsShowSearchResult(false);
  }

  public setCloseEvent(closeEvent: () => void) {
    this.closeIconOnClick = closeEvent;
  }

  // 初始化各个按钮点击事件
  public initEditModeSearchOptions(editModeSearchOptions: EditModeSearchOptions) {
    editModeSearchOptions.searchIconOnClick = this.searchIconOnClick;
    editModeSearchOptions.backIconOnClick = this.backIconOnClick;
    editModeSearchOptions.closeIconOnClick = this.closeIconOnClick;
  }
}
