/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
  ClockLayout,
  LockscreenForm,
  LockscreenFormConfig,
  LockscreenThemeConfig
} from '../../common/WidgetParam';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import {
  AddScreenLockFormDataReportParams,
  DeviceHelper,
  ScreenLockBaseFormDataReportParams
} from '@ohos/frameworkwrapper';
import { HiSysEventUtil } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { CardItemInfo, CommonConstants } from '@ohos/launchercommon';
import ScreenLockFormProxyManager from './ScreenLockFormProxyManager';
import {
  PerformanceMonitorUtil,
  ScreenLockState
} from '@ohos/screenlockcommon';
import { BaseViewModel } from '@ohos/screenlockcommon/Index';
import { ScreenLockFormManagerUtil } from '@ohos/screenlockcommon/Index';
import { clockLayoutHelper } from '../../clock/common/ClockLayoutHelper';
import { clockLayoutParam } from '../../clock/common/ClockLayoutParam';
import Constants from '../common/Constants';
import Want from '@ohos.app.ability.Want';
import { curves, promptAction } from '@kit.ArkUI';
import ScreenLockFormPanelMeshConfig from '../ScreenLockFormPanelMeshConfig';
import { SlFormStaticState } from '../vm/SlFormStaticState';
import AbsDragHandler from '../drag/AbsDragHandler';
import Layout2x2Handler from '../drag/Layout2x2Handler';
import Layout1x4Handler from '../drag/Layout1x4Handler';
import MultiSceneThemeManager from '../../common/theme/MultiSceneThemeManager';
import { systemDateTime } from '@kit.BasicServicesKit';
import { FormAdapterFactory } from '../adapter/FormAdapter'
import { ThemeRemoteManager } from '../../common/theme/ThemeRemoteManager';
import { IAdapter } from '../../common/adapter/BaseAdapter'
import commonEventManager from '@ohos.commonEventManager';
import { ObjectCopyUtil } from '@ohos/componenthelper';

const TAG = 'ScreenLockFormViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const SCREEN_LOCK_FORM_SPACE_LIMIT: number = 4;
const DIMENSION_X_OF_EMPTY_FORM: number = 0;
const DIMENSION_X_OF_1X1_FORM: number = 1;
const DIMENSION_X_OF_1X2_FORM: number = 2;
const SUPPORT_BACKBOARD_FOLD_LAYOUT_HEIGHT: number = 2;
const SUPPORT_BACKBOARD_SINGLE_LINE_LAYOUT_HEIGHT: number = 1;
const THEME_EDIT_MARGIN_BOTTOM: number = 108;
const INVALID_FORM_PANEL_POSITION_Y: number = -1;
const SCREEN_LOCK:number = 6;
const CARD_INDEX_ONE_ROW: number = 2;
const CARD_INDEX_TWO_ROW: number = 3;
const FORM_LOCATION_KEY = 'ohos.extra.param.key.form_location';
const INIT_CARD_ID: string = '0';
const FORM_PRIVACY_KEY = 'isPrivacyScene';

export default class ScreenLockFormViewModel extends BaseViewModel {
  // 组件透明度
  public formComponentOpacity: number = 1;

  public handler?: AbsDragHandler;

  public editStatusBeforeDrag: ScreenLockState = ScreenLockState.THEME_EDITOR_FULL;

  public formAdapter?: IAdapter = FormAdapterFactory.wrapper();

  // 推荐框的位置
  public supportFormPositions: SupportFormLocation[] = [];
  // from的位置及信息
  public formConfigs: LockscreenFormConfig[] = [];
  private clockLayout: ClockLayout = ClockLayout.DIMENSION_4_4;
  // 是否处于编辑态
  private isAddingForm: boolean = false;
  private isDeletingForm: boolean = false;
  private usedCardSpace: number = 0;
  private proxyManager: ScreenLockFormProxyManager = new ScreenLockFormProxyManager();
  // 锁屏卡片推荐框入场延迟
  private supportPositionEntryDelay: number = 0;
  private showFormPanelScene: ShowFormPanelScene = ShowFormPanelScene.POSTER_SCENE;
  // 锁屏卡片面板大小
  private formPanelGridLimit: number = 0;
  public formPanelPositionY: number = 0;
  private formPanelHeight: number = 0;
  private isDownToClockView: boolean = true;
  // 服务卡片静态状态管理
  private slFormStaticState?: SlFormStaticState;
  private _themeParam?: LockscreenThemeConfig;

  public set themeParam(value: LockscreenThemeConfig) {
    this._themeParam = value;
  }

  public onEnterHost(preState: ScreenLockState): void {
    log.showInfo('onEnterHost');
    super.onEnterHost(preState);
    this.updateScene(ShowFormPanelScene.SCREEN_LOCK_MAIN_PAGE);
    this.mDisplayModeChangeListener?.onDisplayModeChange(this.currentMode);
  }

  public onEnterThemeEditor(preState: ScreenLockState): void {
    log.showInfo('onEnterThemeEditor');
    super.onEnterThemeEditor(preState);
    this.updateScene(ShowFormPanelScene.LOCK_SCREEN_EDIT);
    this.mDisplayModeChangeListener?.onDisplayModeChange(this.currentMode);
  }

  public onEnterFullEditor(preState: ScreenLockState, fullState: ScreenLockState): void {
    super.onEnterFullEditor(preState, fullState);
    this.updateScene(fullState === ScreenLockState.THEME_EDITOR_CLOCK_DRAG ||
      fullState === ScreenLockState.THEME_EDITOR_FULL_CLOCK || fullState === ScreenLockState.THEME_EDITOR_FULL ?
    ShowFormPanelScene.LOCK_SCREEN_EDIT : ShowFormPanelScene.ADD_SCREEN_FORM);
    this.mDisplayModeChangeListener?.onDisplayModeChange(this.currentMode);
  }

  public onEnterOtherApp(): void {
    super.onEnterOtherApp();
    this.mDisplayModeChangeListener?.onDisplayModeChange(this.currentMode);
  }

  public onEnterOtherAppBorderShow(): void {
    super.onEnterOtherAppBorderShow();
    this.mDisplayModeChangeListener?.onDisplayModeChange(this.currentMode);
  }

  public onEnterOtherAppBorderHide(): void {
    super.onEnterOtherAppBorderHide();
    this.mDisplayModeChangeListener?.onDisplayModeChange(this.currentMode);
  }

  /**
   * ScreenLockForm
   *
   * @param want 卡片配置卡片参数
   */
  public static getFromWant(): Want {
    let want: Want = {};
    want.parameters = {};
    want.parameters[FORM_LOCATION_KEY] = SCREEN_LOCK;
    want.parameters[FORM_PRIVACY_KEY] = true;
    return want;
  }

  public setSlFormStaticState(state: SlFormStaticState): void {
    this.slFormStaticState = state;
    state?.setFormShowCount(this.usedCardSpace); // 记录可见栅格数
  }

  public getPanelPositionY(): number {
    if (this.isScreenLockMainPage()) {
      return this.formPanelPositionY;
    }
    if (this.isDownToClockView) {
      return this.formPanelPositionY;
    }
    return this.formPanelPositionY - this.formPanelHeight + 1;
  }

  public getRealPositionY(): number {
    let portraitStatus = AppStorage.get<boolean>('isPortrait') as boolean;
    return this.getPanelPositionY() * clockLayoutHelper.getLayoutGridWidth(portraitStatus);
  }

  public getDownToClockView(): boolean {
    return this.isDownToClockView;
  }

  public getSupportPositionEntryDelay(): number {
    return this.supportPositionEntryDelay;
  }

  public getFormPanelScene(): ShowFormPanelScene {
    return this.showFormPanelScene;
  }

  public getIsAddingForm(): boolean {
    return this.isAddingForm;
  }

  public getClockLayout(): ClockLayout {
    return this.clockLayout;
  }

  public getIsDeletingForm(): boolean {
    return this.isDeletingForm;
  }

  public getFormConfigInfo(): LockscreenFormConfig[] {
    return this.formConfigs.filter((item: LockscreenFormConfig) => {
      return item.dimensionX !== 0;
    });
  }

  public getFormPanelGridLimit(): number {
    return this.formPanelGridLimit;
  }

  /**
   * 时钟样式变化后，卡片实际高度
   *
   * @param newClockLayout 新时钟样式
   * @returns 卡片高度
   */
  public getReloadFormHeight(newClockLayout: ClockLayout): number {
    const curCardLayout = ScreenLockFormViewModel.getCardPositionPattern(this.clockLayout);
    const newCardLayout = ScreenLockFormViewModel.getCardPositionPattern(newClockLayout);
    if (curCardLayout === newCardLayout) {
      return this.getCurrentPanelHeight();
    }
    let height: number = 0;
    const defaultSupportPositions: SupportFormLocation[] =
      ScreenLockFormViewModel.getDefaultSupportFormPositions(newCardLayout);
    this.formConfigs = ScreenLockFormViewModel.reloadForm(newCardLayout, this.formConfigs, defaultSupportPositions,
      (item: LockscreenFormConfig, posIndex: number) => {
        ScreenLockFormViewModel.updatePositionShowing(defaultSupportPositions, posIndex, item, false);
        height = Math.max(defaultSupportPositions[posIndex].positionY + 1, height);
      });
    return height;
  }

  public getCurrentPanelHeight(): number {
    let formHeight: number = 0;
    this.formConfigs.forEach((item: LockscreenFormConfig) => {
      if (item.dimensionX !== 0) {
        formHeight = Math.max(formHeight, item.positionY + 1);
      }
    })
    return formHeight;
  }

  public getFormPanelHeight(): number {
    return this.formPanelHeight;
  }

  public registerRouterProxy(formId: string): void {
    if (!this.proxyManager) {
      return;
    }
    this.proxyManager.registerRouterProxy(formId);
  }

  /**
   * 应用卸载事件回调
   * @param subscriber
   * @param callback
   */
  public handleSubscriberCallback = (eventData: commonEventManager.CommonEventData): void => {
    if (eventData.event === commonEventManager.Support.COMMON_EVENT_PACKAGE_REMOVED) {
      log.info('package_removed, bundlename: ' + eventData.bundleName);
      // 如果卡片bundleName和卸载应用相同，则直接删除卡片信息
      let isNeedUpdateFormConfigs: boolean = false;
      this.formConfigs.filter(item => item.formInfo.bundleName === eventData.bundleName).forEach(item => {
        isNeedUpdateFormConfigs = true;
        log.showInfo(`screen lock form removed, bundlename = ${eventData.bundleName} positionX = ${item.positionX}, positionY = ${item.positionY},` +
          `dimention = ${item.dimensionX}, formPanelHeight: ${this.formPanelHeight}, formId: ${item.formInfo.cardId}`);
        let dimensionX: number = item.dimensionX;
        this.showSupportPosition(item);
        this.deleteFromConfig(item);
        this.setUsedCardSpace(this.usedCardSpace - dimensionX);
      })
      if (isNeedUpdateFormConfigs) {
        this.updateThemeCfgByFormConfigs();
      }
      return;
    }
  };

  public clearAbilityQueue(): void {
    if (!this.proxyManager) {
      return;
    }
    if (!this.isScreenLockMainPage()) {
      return;
    }
    this.proxyManager.clearAbilityQueue();
  }

  public updateScene(scene: ShowFormPanelScene): void {
    log.showInfo(`updateScene, scene = ${scene}`);
    if (this.showFormPanelScene === scene) {
      log.showInfo('The showFormPanelScene is same.');
      this.initEditFormPanelParam(scene);
      this.initFormPanelHeight(this.clockLayout);
      return;
    }
    this.showFormPanelScene = scene;
    this.initEditFormPanelParam(scene);
    this.initFormPanelHeight(this.clockLayout);
    this.initSupportFormPositions();
    this.resetSupportPositionEntryDelay(scene);
  }

  public updateLayout(newClockLayout: ClockLayout, clockViewPositionY: number): void {
    log.showInfo(`updateLayout, clockLayout = ${newClockLayout}`);
    this.initFormPanelSpace(clockViewPositionY);
    this.updateFormPosition(newClockLayout);
    this.clockLayout = newClockLayout;
    this.initFormPanelHeight(newClockLayout);
  }

  public isDoubleLineLayout(clockLayout: ClockLayout = this.clockLayout): boolean {
    return ScreenLockFormViewModel.getCardPositionPattern(clockLayout) === CardLayout.TWO_ROW;
  }

  public getFormIndex(form: LockscreenFormConfig): number {
    let newIndex: number = -1;
    let sourceKey: string = this.getForEachKey(form);
    // 锁屏编辑不应用场景，ForEach中数组对象会因深拷贝还原而改变，indexOf无法获取正确值，故遍历数组通过key值比对
    this.formConfigs.forEach((item, index) => {
      if (this.getForEachKey(item) === sourceKey) {
        newIndex = index;
      }
    })
    return newIndex;
  }

  public getForEachKey(item: LockscreenFormConfig): string {
    return `${item.dimensionX}_${item.formInfo?.bundleName}_${item.formInfo?.cardName}_${item.formInfo?.tempId}`;
  }

  protected resetSupportPositionEntryDelay(scene: ShowFormPanelScene): void {
    if (scene !== ShowFormPanelScene.ADD_SCREEN_FORM) {
      return;
    }
    // 更新scene为ADD_SCREEN_FORM时，卡片推荐框入场动画需要延迟50ms
    this.supportPositionEntryDelay = 50;
    setTimeout(() => {
      this.supportPositionEntryDelay = 0;
    }, Constants.MILLISECOND_TO_SECOND);
  }

  private updateFormPosition(newClockLayout: ClockLayout): void {
    if (this.clockLayout === newClockLayout) {
      return;
    }
    this.updateLayoutHandler(newClockLayout);
    this.reloadFormPosition(newClockLayout);
  }

  protected reloadFormPosition(newClockLayout: ClockLayout): void {
    const curCardLayout = ScreenLockFormViewModel.getCardPositionPattern(this.clockLayout);
    const newCardLayout = ScreenLockFormViewModel.getCardPositionPattern(newClockLayout);
    if (curCardLayout !== newCardLayout) {
      log.showInfo(`reload form position，cur: ${curCardLayout} new: ${newCardLayout}`);
      this.supportFormPositions = ScreenLockFormViewModel.getDefaultSupportFormPositions(newCardLayout);
      this.formConfigs = this.reloadFormPositionByLayout(newClockLayout, this.formConfigs);
      MultiSceneThemeManager.updateFormPosition(this.formConfigs);
    }
  }

  private updateLayoutHandler(newClockLayout: ClockLayout): void {
    const newCardLayout = ScreenLockFormViewModel.getCardPositionPattern(newClockLayout);
    this.handler = newCardLayout === CardLayout.ONE_ROW ? new Layout1x4Handler() : new Layout2x2Handler();
  }

  private reloadFormPositionByLayout(clockLayout: ClockLayout,
    formConfigs: LockscreenFormConfig[]): LockscreenFormConfig[] {
    let reloadFormConfig: LockscreenFormConfig[] = [];
    const newCardLayout = ScreenLockFormViewModel.getCardPositionPattern(clockLayout);
    const defaultSupportPositions: SupportFormLocation[] =
      ScreenLockFormViewModel.getDefaultSupportFormPositions(newCardLayout);
    ScreenLockFormViewModel.reloadForm(newCardLayout, formConfigs, defaultSupportPositions,
      (item: LockscreenFormConfig, posIndex: number) => {
        ScreenLockFormViewModel.addFormToSupportPosition(item, posIndex, defaultSupportPositions);
        reloadFormConfig.push(item);
      });
    return reloadFormConfig;
  }

  /**
   * 将formConfig的信息按照newClockLayout的始终布局进行转换
   * @param newClockLayout  目标时钟布局
   * @param currentClockLayout  当前时钟布局
   * @param formConfigs  当前卡片的信息
   */
  public static adjustFormConfigs(newClockLayout: ClockLayout, currentClockLayout: ClockLayout,
    formConfigs: LockscreenFormConfig[]): void {
    // 需要判断卡片的布局是否相同
    const newCardLayout = ScreenLockFormViewModel.getCardPositionPattern(newClockLayout);
    const currentCardLayout = ScreenLockFormViewModel.getCardPositionPattern(currentClockLayout);
    if (newCardLayout === currentCardLayout) {
      log.showInfo(`same layout: ${currentCardLayout}`);
      return;
    }
    log.showInfo(`adjustFormConfigs cur: ${currentCardLayout}, new: ${newCardLayout}`);
    const defaultSupportPositions: SupportFormLocation[] =
      ScreenLockFormViewModel.getDefaultSupportFormPositions(newCardLayout);
    ScreenLockFormViewModel.reloadForm(newCardLayout, formConfigs, defaultSupportPositions,
      (item: LockscreenFormConfig, posIndex: number) => {
        if (posIndex < 0 || posIndex >= defaultSupportPositions.length) {
          log.showWarn('adjustFormConfigs invalid posIndex');
          return;
        }
        item.positionX = defaultSupportPositions[posIndex].positionX;
        item.positionY = defaultSupportPositions[posIndex].positionY;
        ScreenLockFormViewModel.updatePositionShowing(defaultSupportPositions, posIndex, item, false);
      });
  }

  /**
   * 根据当前卡片缓存信息formConfigs，更新主题持久化信息
   */
  public updateThemeCfgByFormConfigs(): void {
    log.showInfo(`updateThemeCfgByFormConfigs,new config: ${this.printFormConfig(this.formConfigs)}`);
    // 组装新的form信息
    let formConfig: LockscreenForm = new LockscreenForm();
    formConfig.list = this.getFormConfigInfo();
    formConfig.positionY = this.getPanelPositionY();
    let mThemeManager: ThemeRemoteManager = new ThemeRemoteManager();
    if (MultiSceneThemeManager.isSupportMultiSceneTheme()) {
      MultiSceneThemeManager.initEditorThemeInfo();
      MultiSceneThemeManager.updateEditorCacheThemeInfo(formConfig);
      mThemeManager.setMultiSceneThemeCfg(MultiSceneThemeManager.getMultiSceneThemeEditCfg());
    } else if (this._themeParam !== undefined) {
      this._themeParam.form.list = this.formConfigs;
      mThemeManager.setCurrentThemeCfg(this._themeParam);
    }
  }

  private static addFormToSupportPosition(item: LockscreenFormConfig, posIndex: number,
    defaultSupportPositions: SupportFormLocation[]): void {
    if (!item || !defaultSupportPositions[posIndex]) {
      log.showInfo('addFormToSupportPosition item is undefined');
      return;
    }
    item.positionX = defaultSupportPositions[posIndex].positionX;
    item.positionY = defaultSupportPositions[posIndex].positionY;
    ScreenLockFormViewModel.updatePositionShowing(defaultSupportPositions, posIndex, item, false);
    log.showInfo(`add form, posIndex ,${posIndex}, ${item.positionX}, ${item.positionY}`);
  }

  private static updatePositionShowing(defaultSupportPositions: SupportFormLocation[], posIndex: number,
    item: LockscreenFormConfig, showStatus: boolean): void {
    defaultSupportPositions[posIndex].isShow = showStatus;
    if (item.dimensionX === DIMENSION_X_OF_1X2_FORM) {
      if (RTLUtil.isRTL() && posIndex - 1 > -1) {
        defaultSupportPositions[posIndex - 1].isShow = showStatus;
      }
      if (!RTLUtil.isRTL() && posIndex + 1 < SCREEN_LOCK_FORM_SPACE_LIMIT) {
        defaultSupportPositions[posIndex + 1].isShow = showStatus;
      }
    }
  }

  private static getDefaultSupportFormPositions(cardLayout: CardLayout): SupportFormLocation[] {
    const isRtl: boolean = RTLUtil.isRTL();
    let res: SupportFormLocation[] = [];
    if (CardLayout.TWO_ROW === cardLayout) {
      return [{
        positionX: isRtl ? 2 : 1, positionY: 0, isShow: true
      }, {
        positionX: isRtl ? 1 : 2, positionY: 0, isShow: true
      }, {
        positionX: isRtl ? 2 : 1, positionY: 1, isShow: true
      }, {
        positionX: isRtl ? 1 : 2, positionY: 1, isShow: true
      }];
    }
    res = [{
      positionX: 0, positionY: 0, isShow: true
    }, {
      positionX: 1, positionY: 0, isShow: true
    }, {
      positionX: 2, positionY: 0, isShow: true
    }, {
      positionX: 3, positionY: 0, isShow: true
    }];
    return isRtl ? res.reverse() : res;
  }

  private static getCardPositionPattern(clockLayout: ClockLayout): CardLayout {
    if (clockLayout === ClockLayout.DIMENSION_4_2 ||
      clockLayout === ClockLayout.DIMENSION_4_4 ||
      clockLayout === ClockLayout.DEFAULT_CLOCK_LAYOUT ||
      clockLayout === ClockLayout.DEFAULT_CLOCK_SPECIAL ||
      clockLayout === ClockLayout.DEFAULT_CLOCK_REVERSE_LAYOUT) {
      return CardLayout.TWO_ROW;
    }
    return CardLayout.ONE_ROW;
  }

  private static reloadForm(newCardLayout: CardLayout, formConfigs: LockscreenFormConfig[],
    defaultSupportPositions: SupportFormLocation[],
    callback: (item: LockscreenFormConfig, posIndex: number) => void): LockscreenFormConfig[] {
    log.showInfo(`reloadForm formConfigs length is ${formConfigs.length}`);
    let newFormConfigs = formConfigs
      .filter((item: LockscreenFormConfig) => item.dimensionX !== DIMENSION_X_OF_EMPTY_FORM);
    // 如果有1x2卡片且卡片被重排后会被截断则需要重排
    const indexOf1x2Card: number =
      newFormConfigs.findIndex((item: LockscreenFormConfig) => item.dimensionX === DIMENSION_X_OF_1X2_FORM);
    const has1x2Card: boolean = indexOf1x2Card >= 0;
    const is1x2CardCutOff = has1x2Card && newFormConfigs[indexOf1x2Card].positionX === 1;
    newFormConfigs.forEach((item: LockscreenFormConfig) => {
      let posIndex: number = 0;
      if (CardLayout.ONE_ROW === newCardLayout) {
        posIndex = RTLUtil.isRTL() ? (CARD_INDEX_ONE_ROW - item.positionX) + item.positionY * 2 :
          (item.positionX - 1) + item.positionY * 2;
        if (posIndex < 0) {
          posIndex = 0;
        }
      } else if (has1x2Card && is1x2CardCutOff) {
        posIndex = ScreenLockFormViewModel.calculateFormLocation(item.dimensionX, defaultSupportPositions, false,
          false);
      } else {
        posIndex = RTLUtil.isRTL() ? (CARD_INDEX_TWO_ROW - item.positionX) + item.positionY :
          item.positionX + item.positionY * 2;
        if (posIndex < 0) {
          posIndex = 0;
        }
      }
      log.showInfo(`reloadForm dimensionX: ${item.dimensionX}, posIndex: ${posIndex}`);
      if (posIndex < 0 || posIndex >= defaultSupportPositions.length) {
        log.showWarn('posIndex length cannot out of range');
        return;
      }
      callback(item, posIndex);
    });
    return newFormConfigs;
  }

  protected static calculateFormLocation(dimensionX: number, supportFormPositions: SupportFormLocation[],
    isDrag: boolean = false, isCardLayoutTwoRow: boolean): number {
    let posIndex: number = 0;
    if (dimensionX === DIMENSION_X_OF_1X1_FORM || isDrag) {
      posIndex = ScreenLockFormViewModel.getIndexForDimension1X1Form(dimensionX, supportFormPositions,
        isCardLayoutTwoRow);
    } else if (dimensionX === DIMENSION_X_OF_1X2_FORM) {
      posIndex = ScreenLockFormViewModel.getIndexForDimension1X2Form(supportFormPositions);
    }
    return posIndex;
  }

  private static getIndexForDimension1X1Form(dimensionX: number, supportFormPositions: SupportFormLocation[],
    isCardLayoutTwoRow: boolean): number {
    let index = 0;
    // 镜像语言下时钟布局为横向，拖拽添加1*2卡片 防止1*2卡片错位
    if (RTLUtil.isRTL() && dimensionX === DIMENSION_X_OF_1X2_FORM && !isCardLayoutTwoRow) {
      index = ScreenLockFormViewModel.getIndexForDimension1X2Form(supportFormPositions);
      return index;
    }
    for (; index < supportFormPositions.length; index++) {
      if (supportFormPositions[index].isShow) {
        return index;
      }
    }
    return index;
  }

  private static getIndexForDimension1X2Form(supportFormPositions: SupportFormLocation[]): number {
    let index = 0;
    for (; index < supportFormPositions.length - 1; index++) {
      if (!supportFormPositions[index].isShow || !supportFormPositions[index + 1].isShow) {
        continue;
      }
      if (supportFormPositions[index].positionY === supportFormPositions[index + 1].positionY) {
        return RTLUtil.isRTL() ? index + 1 : index;
      }
    }
    return ++index;
  }

  public initFormPanelSpace(clockViewPositionY: number): void {
    let portraitStatus = AppStorage.get<boolean>('isPortrait') as boolean;
    const layoutGridAmountY: number = clockLayoutHelper.getLayoutGridAmount(portraitStatus).y;
    const clockViewAmountY: number = clockLayoutParam.gridParam.gridHeightAmount;
    this.formPanelGridLimit = layoutGridAmountY - (clockViewPositionY + clockViewAmountY);
    if (this.formPanelGridLimit <= 0 && clockViewPositionY === 0) {
      log.showError('Invalid clockView positionY.');
      this.formPanelGridLimit = SUPPORT_BACKBOARD_FOLD_LAYOUT_HEIGHT;
      this.formPanelPositionY = clockViewPositionY + clockViewAmountY;
      return;
    }
    // 向上布局,在时钟的
    if (this.formPanelGridLimit === 0) {
      this.hasAddedCard() ? this.formPanelHeight = 1 : this.formPanelHeight = 0;
      this.formPanelGridLimit = clockViewPositionY;
      this.formPanelPositionY = clockViewPositionY - 1;
      this.isDownToClockView = false;
      return;
    }
    this.formPanelPositionY = clockViewPositionY + clockViewAmountY;
    this.isDownToClockView = true;
  }

  public hasAddedCard(): boolean {
    log.showDebug(`hasAddedCard, this.formConfigs.length = ${this.formConfigs.length}`);
    return this.usedCardSpace !== 0;
  }

  public isScreenLockMainPage(): boolean {
    return this.showFormPanelScene === ShowFormPanelScene.SCREEN_LOCK_MAIN_PAGE;
  }

  viewModelInitOnScreenLock(formConfigs: LockscreenFormConfig[], clockLayout: ClockLayout,
    formPanelPositionY: number = INVALID_FORM_PANEL_POSITION_Y) {
    this.initEditFormPanelParam(ShowFormPanelScene.SCREEN_LOCK_MAIN_PAGE);
    log.showInfo(`viewModelInitOnScreenLock, formConfigs = ${this.printFormConfig(formConfigs)},
     clockLayout = ${clockLayout}, positionY = ${formPanelPositionY}`);
    this.initFormConfigInfo(formConfigs);
    this.formPanelPositionY = this.calculateDefaultFormPanelPositionY(formPanelPositionY, clockLayout);
    this.clockLayout = clockLayout;
    this.initFormPanelHeight(this.clockLayout);
    this.updateLayoutHandler(clockLayout);
  }

  viewModelInit(formConfigs: LockscreenFormConfig[], clockLayout: ClockLayout, scene: ShowFormPanelScene,
    clockViewPositionY: number = 0): void {
    log.showInfo(`viewModelInit, formConfigs = ${this.printFormConfig(formConfigs)}, clockLayout = ${clockLayout}`);
    this.clockLayout = clockLayout;
    this.initEditFormPanelParam(scene);
    this.initFormPanelSpace(clockViewPositionY);
    this.initFormConfigInfo(formConfigs);
    this.initSupportFormPositions();
    this.initFormPanelHeight(this.clockLayout);
    this.updateLayoutHandler(clockLayout);
  }

  public calculateDefaultFormPanelPositionY(formPanelPositionY: number, clockLayout: ClockLayout): number {
    if (formPanelPositionY !== INVALID_FORM_PANEL_POSITION_Y) {
      return formPanelPositionY;
    }
    return clockLayoutParam.gridParam.gridHeightAmount;
  }

  /**
   * addForm
   *
   * @param formItem
   */
  public addScreenLockForm(formItem: CardItemInfo, location: number, isDrag: boolean = false): number {
    let params: AddScreenLockFormDataReportParams = {
      FORMID: formItem.cardId,
      PACKAGENAME: (formItem.bundleName as string),
      CARDDIMENSION: formItem.cardDimension.toString(),
      MODULENAME: (formItem.moduleName as string),
      FORMNAME: (formItem.cardName as string),
      LOCATION: location,
    };
    HiSysEventUtil.reportAddScreenLockFormData(params);
    log.showInfo(`add screen lock form, bundleName = ${formItem.bundleName}`);
    const dimensionX: number =
      formItem.cardDimension === CommonConstants.CARD_DIMENSION_1x2 ? DIMENSION_X_OF_1X2_FORM : DIMENSION_X_OF_1X1_FORM;
    let formSpaceLimit: number = SCREEN_LOCK_FORM_SPACE_LIMIT;
    const isCardLayoutTwoRow: boolean = ScreenLockFormViewModel.getCardPositionPattern(this.clockLayout) ===
      CardLayout.TWO_ROW;
    if (this.formPanelGridLimit === 1 && isCardLayoutTwoRow) {
      formSpaceLimit /= 2;
    }
    if (this.usedCardSpace + dimensionX > formSpaceLimit) {
      this.showToastWhenNoFormSpace();
      return -1;
    }
    let posIndex: number = ScreenLockFormViewModel.calculateFormLocation(dimensionX, this.supportFormPositions, isDrag,
      isCardLayoutTwoRow);
    if (posIndex >= formSpaceLimit) {
      this.showToastWhenNoFormSpace();
      return -1;
    }

    if (this.supportFormPositions[posIndex].positionY >= this.formPanelGridLimit) {
      this.showToastWhenNoFormSpace();
      return -1;
    }
    formItem.cardId = INIT_CARD_ID;
    let index = this.addForm(posIndex, dimensionX, formItem, isDrag);
    this.setUsedCardSpace(this.usedCardSpace + dimensionX);
    return index;
  }

  private printFormConfig(formConfigs: LockscreenFormConfig[]): string {
    let str = '';
    formConfigs.forEach((formConfig => {
      str += this.formConfigToString(formConfig);
    }))
    return str;
  }

  private formConfigToString(formConfig: LockscreenFormConfig): string {
    return `[{"positionX": ${formConfig?.positionX},"positionY": ${formConfig?.positionY},` +
      `"dimensionX": ${formConfig?.dimensionX},"formInfo": {"typeId": ${formConfig?.formInfo?.typeId},` +
      `"cardId": ${formConfig?.formInfo?.cardId},"bundleName": ${formConfig?.formInfo?.bundleName},` +
      `"abilityName": ${formConfig?.formInfo?.abilityName},"moduleName": ${formConfig?.formInfo?.moduleName},` +
      `"tempId": ${formConfig?.formInfo?.tempId}}}]`;
  }

  private addForm(posIndex: number, dimensionX: number, formItem: CardItemInfo, isdrag: boolean): number {
    log.showInfo(`add form, posIndex = ${posIndex}, dimensionX = ${dimensionX}, formPanelHeight: ${this.formPanelHeight}`);
    if (!isdrag) {
      PerformanceMonitorUtil.reportLockscreenEditCardAdd(
        formItem.cardId.toString(),
        formItem.bundleName,
        formItem.cardDimension.toString(),
        formItem.moduleName,
        formItem.description
      );
    }
    const newFormInfo: LockscreenFormConfig = {
      positionX: 0,
      positionY: 0,
      dimensionX: dimensionX,
      formInfo: formItem
    };
    ScreenLockFormViewModel.addFormToSupportPosition(newFormInfo, posIndex, this.supportFormPositions);
    return this.saveFormInfo(newFormInfo);
  }

  protected saveFormInfo(newFormInfo: LockscreenFormConfig): number {
    let isAdded: boolean = false;
    for (let formConfig of this.formConfigs) {
      if (formConfig.dimensionX !== 0) {
        continue;
      }
      if (formConfig.positionX === newFormInfo.positionX && formConfig.positionY === newFormInfo.positionY) {
        formConfig.dimensionX = newFormInfo.dimensionX;
        formConfig.formInfo = newFormInfo.formInfo;
        isAdded = true;
        break;
      }
    }
    if (!isAdded) {
      this.formConfigs = this.formConfigs.concat(newFormInfo);
    }
    return this.formConfigs.indexOf(newFormInfo);
  }

  protected initEditFormPanelParam(scene: ShowFormPanelScene): void {
    this.showFormPanelScene = scene;
    switch (scene) {
      case ShowFormPanelScene.POSTER_SCENE:
        this.isAddingForm = false;
        this.isDeletingForm = false;
        break;
      case ShowFormPanelScene.LOCK_SCREEN_EDIT:
        this.isAddingForm = !this.isArtClock();
        this.isDeletingForm = false;
        break;
      case ShowFormPanelScene.ADD_SCREEN_FORM:
        this.isAddingForm = true;
        this.isDeletingForm = true;
        break;
      case ShowFormPanelScene.SCREEN_LOCK_MAIN_PAGE:
        this.isAddingForm = false;
        this.isDeletingForm = false;
        break;
      default:
        break;
    }
  }

  private isArtClock(): boolean {
    // 当前艺术签名屏蔽卡片添加
    return this.clockLayout >= 200;
  }

  protected setUsedCardSpace(space: number): void { // 卡片已用栅格数
    if (this.usedCardSpace === space) {
      return;
    }
    this.usedCardSpace = space;
    animateTo({
      curve: curves.interpolatingSpring(0, 1, 228, 30)
    }, () => {
      this.slFormStaticState?.setFormShowCount(space);
    })
  }

  public getUsedCardSpace(): number {
    return this.usedCardSpace;
  }

  /**
   * 通过卡片id获取卡片失败之后，重新创建卡片
   * @param lockscreenFormConfigs 获取失败的卡片信息
   * @param themeId 主题id
   * @param themeName 主题name
   */
  public reloadScreenLockForm(lockscreenFormConfigs: LockscreenFormConfig[], themeId: string, themeName: string): void {
    // 如果卡片id是0，表示创建失败，则直接删除卡片信息
    lockscreenFormConfigs.filter(item => item.formInfo.cardId === '0').forEach(item => {
      this.deleteScreenLockForm(item, themeId, themeName);
    })
    const needReloadCardIds: string[] =
      lockscreenFormConfigs.filter(item => item.formInfo.cardId !== '0').map(item => item.formInfo.cardId);
    log.showInfo(`reloadScreenLockForm cardIds ${needReloadCardIds}`);
    if (needReloadCardIds.length === 0) {
      return;
    }
    this.formConfigs = this.formConfigs.map(item => {
      if (needReloadCardIds.includes(item.formInfo.cardId)) {
        item.formInfo.cardId = '0';
        item.formInfo.tempId = systemDateTime.getTime(true).toString();
      }
      return item;
    })
    log.showInfo(`reloadScreenLockForm end ${this.printFormConfig(this.formConfigs)}`);
  }

  /**
   * deleteScreenLockForm
   *
   * @param lockscreenFormConfig 卡片配置信息
   * @param themeId 主题id
   * @param themeName 主题name
   */
  public deleteScreenLockForm(lockscreenFormConfig: LockscreenFormConfig, themeId: string, themeName: string): void {
    let params: ScreenLockBaseFormDataReportParams = {
      THEMEID: themeId,
      FORMID: lockscreenFormConfig.formInfo.cardId,
      PACKAGENAME: (lockscreenFormConfig.formInfo.bundleName as string),
      CARDDIMENSION: lockscreenFormConfig.formInfo.cardDimension.toString(),
      MODULENAME: (lockscreenFormConfig.formInfo.moduleName as string),
      FORMNAME: (lockscreenFormConfig.formInfo.cardName as string),
      THEMENAME: themeName
    };
    HiSysEventUtil.reportRemoveScreenLockFormData(params);
    log.showWarn(`delete screen lock form, positionX = ${lockscreenFormConfig.positionX}, positionY = ${lockscreenFormConfig.positionY},` +
      `dimention = ${lockscreenFormConfig.dimensionX}, formPanelHeight: ${this.formPanelHeight}, formId: ${lockscreenFormConfig.formInfo.cardId}`);
    let dimensionX: number = lockscreenFormConfig.dimensionX;
    this.showSupportPosition(lockscreenFormConfig);
    this.deleteFromConfig(lockscreenFormConfig);
    this.setUsedCardSpace(this.usedCardSpace - dimensionX);
    PerformanceMonitorUtil.reportLockscreenEditCardRemove(
      lockscreenFormConfig.formInfo.cardId.toString(),
      lockscreenFormConfig.formInfo.bundleName as string,
      lockscreenFormConfig.formInfo.cardDimension.toString(),
      lockscreenFormConfig.formInfo.moduleName as string,
      lockscreenFormConfig.formInfo.cardName as string
    );
  }

  private showSupportPosition(formConfig: LockscreenFormConfig): void {
    for (let index = 0; index < this.supportFormPositions.length; index++) {
      if (this.supportFormPositions[index].positionX !== formConfig.positionX ||
        this.supportFormPositions[index].positionY !== formConfig.positionY) {
        continue;
      }
      ScreenLockFormViewModel.updatePositionShowing(this.supportFormPositions, index, formConfig, true);
      return;
    }
  }

  private deleteFromConfig(formInfo: LockscreenFormConfig): void {
    this.formConfigs = this.formConfigs.filter((item: LockscreenFormConfig) => {
      return item.positionX !== formInfo.positionX || item.positionY !== formInfo.positionY;
    });
    ScreenLockFormManagerUtil.deleteFormById(formInfo.formInfo.cardId);
  }

  private showToastWhenNoFormSpace(): void {
    log.showInfo('No space to add screenLock form.');
    promptAction.showToast({
      message: ResUtils.getInnerStringByName('add_form_to_screen_lock_editor_max'),
      showMode: 2,
      bottom: THEME_EDIT_MARGIN_BOTTOM
    });
  }

  public initFormConfigInfo(initFormConfigs: LockscreenFormConfig[]): void {
    let isValidFormInfo: boolean = this.validateFormConfig(initFormConfigs);
    let oldCards: string[] = this.formConfigs.map(item => item.formInfo.cardId);
    if (!isValidFormInfo) {
      this.formConfigs = [];
      this.setUsedCardSpace(0);
    } else {
      this.formConfigs = ObjectCopyUtil.deepClone(initFormConfigs);
    }
    log.showInfo(`viewModelInit, this formConfigs: ${this.printFormConfig(this.formConfigs)}`)
    // 如果出现新的id，需要改变tempId，防止卡片不刷新
    this.formConfigs.forEach(item => {
      if (!oldCards.includes(item.formInfo.cardId)) {
        item.formInfo.tempId = systemDateTime.getTime(true).toString();
      }
    })
    // 将需要继续使用id剔除，然后删旧卡
    const newCards: string[] = this.formConfigs.map(item => item.formInfo.cardId);
    log.showInfo(`viewModelInit oldCards ${oldCards}, newCards ${newCards}`)
    oldCards.filter(cardId =>!newCards.includes(cardId)).forEach(cardId => {
      ScreenLockFormManagerUtil.deleteFormById(cardId);
    });
  }

  private initFormPanelHeight(clockLayout: ClockLayout): void {
    let initHeight: number = 0;
    if (this.isAddingForm || this.isDeletingForm) {
      initHeight = this.isDoubleLineLayout(clockLayout) ?
        SUPPORT_BACKBOARD_FOLD_LAYOUT_HEIGHT : SUPPORT_BACKBOARD_SINGLE_LINE_LAYOUT_HEIGHT;
    }
    if (this.formConfigs.length !== 0) {
      this.formConfigs.forEach((formItem: LockscreenFormConfig) => {
        if ((formItem.positionY + 1) > initHeight && formItem.dimensionX !== 0) {
          initHeight = formItem.positionY + 1;
        }
      });
    }
    if ((this.formPanelPositionY <= initHeight || this.formPanelHeight === 0) && !this.isDownToClockView) {
      initHeight = this.formPanelHeight;
    }
    this.formPanelHeight = initHeight;
    if (this.formPanelGridLimit === 1) {
      this.formPanelHeight = 1;
    }
    log.showInfo(`clockLayout: ${this.clockLayout}, formPanelGridLimit: ${this.formPanelGridLimit}, formPanelHeight: ${this.formPanelHeight}`);
  }

  private validateFormConfig(initFormConfigs: LockscreenFormConfig[]): boolean {
    if (!initFormConfigs || initFormConfigs.length === 0) {
      log.showInfo('the formConfig is empty.');
      return false;
    }
    let existInvalidFormInfo: boolean = false;
    let useCardCount: number = 0;
    initFormConfigs.forEach((formItem: LockscreenFormConfig) => {
      if (!formItem.formInfo) {
        log.showInfo('exist invalid formInfo.');
        existInvalidFormInfo = true;
      }
      if (formItem.dimensionX < DIMENSION_X_OF_EMPTY_FORM || formItem.dimensionX > DIMENSION_X_OF_1X2_FORM) {
        log.showInfo('exist invalid form, of which the size is too big.');
        existInvalidFormInfo = true;
      }
      useCardCount += (formItem?.dimensionX ?? 0);
    });
    this.setUsedCardSpace(useCardCount);

    return !existInvalidFormInfo && this.usedCardSpace <= SCREEN_LOCK_FORM_SPACE_LIMIT;
  }

  private initSupportFormPositions(): void {
    const curCardLayout = ScreenLockFormViewModel.getCardPositionPattern(this.clockLayout);
    let defaultSupportFormPosition = ScreenLockFormViewModel.getDefaultSupportFormPositions(curCardLayout);
    if (this.formConfigs.length === 0) {
      this.supportFormPositions = defaultSupportFormPosition;
      return;
    }
    for (const supportFormPos of defaultSupportFormPosition) {
      for (const form of this.formConfigs) {
        if (this.isSupportFormPosOccupied(supportFormPos, form)) {
          supportFormPos.isShow = false;
          break;
        }
      }
    }
    this.supportFormPositions = defaultSupportFormPosition;
  }

  protected isSupportFormPosOccupied(supportFormPos: SupportFormLocation, form: LockscreenFormConfig): boolean {
    if (form.dimensionX === DIMENSION_X_OF_EMPTY_FORM) {
      return false;
    }
    if (supportFormPos.positionY !== form.positionY) {
      return false;
    }
    return supportFormPos.positionX === form.positionX ||
      (form.dimensionX === DIMENSION_X_OF_1X2_FORM && supportFormPos.positionX === form.positionX + 1);
  }

  public updatePanelHeight(): void {
    let initHeight: number = 0;
    let formConfigs = this.getFormConfigInfo();
    if (formConfigs.length !== 0) {
      formConfigs.forEach((formItem: LockscreenFormConfig) => {
        if ((formItem.positionY + 1) > initHeight && formItem.dimensionX !== 0) {
          initHeight = formItem.positionY + 1;
        }
      });
    }
    log.showInfo(`updatePanelHeight ${initHeight}`);
    this.formPanelHeight = initHeight;
    ScreenLockFormPanelMeshConfig.setPanelHeight(initHeight);
  }
}

export enum CardLayout {
  ONE_ROW = 1,
  TWO_ROW = 2,
}

export class SupportFormLocation {
  public isShow: boolean = false;
  public positionX: number = 0;
  public positionY: number = 0;
}

export enum ShowFormPanelScene {
  POSTER_SCENE,
  LOCK_SCREEN_EDIT,
  ADD_SCREEN_FORM,
  SCREEN_LOCK_MAIN_PAGE
}