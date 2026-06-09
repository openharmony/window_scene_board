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

import { AppItemInfo, CardItemInfo, FormCommonUtil } from '@ohos/launchercommon';
import { DragDataType, DragExtraInfo } from '@ohos/componentdrag';
import { clockLayoutHelper } from '../clock/common/ClockLayoutHelper';
import { AestheticColorArgs, LockscreenFormConfig } from '../common/WidgetParam';
import ScreenLockFormViewModel from './vm/ScreenLockFormViewModel';
import {
  SlVisualArgs,
  CcmOption,
  GlobalStatusCache,
  ScreenLockState,
  screenLockInnerStateManager,
  SlAreaType,
  SlPositionType,
  StatusCacheConst,
  vibratorMgr,
  WBaseProperty
} from '@ohos/screenlockcommon';
import {
  Trace,
  LogDomain,
  LogHelper, PixelMapUtil,
} from '@ohos/basicutils';
import {
  HiSysEventUtil,
  EventManager,
  EvtBus,
  ScreenOnOffEvent,
  GlobalContext,
  ScreenLockFormDataReportParamsState,
  sEventManager,
  DeviceHelper,
} from '@ohos/frameworkwrapper';
import { SCBScreenProperty, ResUtils } from '@ohos/windowscene';
import ScreenLockPreferencesUtil from './common/ScreenLockPreferencesUtil';
import { FormComponentBuilder } from './vm/FormComponentBuilder';
import Base from '@ohos.base';
import formHost from '@ohos.app.form.formHost';
import {
  DisplayModeChangeListener,
  NONE_EDIT_MODE,
  EDIT_FULL_MODE,
  EDIT_GUIDE_MODE,
  EDIT_FORM_MODE_MAIN,
  EDIT_FORM_MODE_DETAIL,
} from '@ohos/screenlockcommon/Index';
import { PerformanceMonitorUtil } from '@ohos/screenlockcommon';
import { CardItemUEInfo } from '@ohos/screenlockcommon/src/main/ets/record/report/PerformanceMonitorUtil';
import { FormPanelChange } from './ScreenLockFormPanelModel';
import ScreenLockFormPanelMeshConfig from './ScreenLockFormPanelMeshConfig';
import { ColorType } from '../editsheet/models/MainColor';
import {
  EDIT_CLOCK_DRAG,
  EDIT_FORM_DRAG,
  ENTER_OTHER_APP_BORDER_SHOW,
  ENTER_OTHER_APP_BORDER_HIDE
} from '@ohos/screenlockcommon/src/main/ets/base/BaseViewModel';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import curves from '@ohos.curves';
import { DynamicFontSize, sFontScaleUtil } from '../common/utils/FontScaleUtil';
import { SlWidgetId } from '@ohos/screenlockcommon/src/main/ets/constants/SlWidgetConst';
import { slStateHelper } from '../common/utils/SlStateHelper';
import { SlClockBindState } from '../clock/model/data/SlClockBindState';
import { clockLayoutParam } from '../clock/common/ClockLayoutParam';
import { LengthMetrics } from '@ohos.arkui.node';
import FormPlaceHolderInfo from './drag/FormPlaceHolderInfo';
import componentSnapshot from '@ohos.arkui.componentSnapshot';
import FormProxy from './remote/FormProxy';
import {
  FormDisplayType,
  FormCenterLocation,
  FormCenterViewParam
} from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { SlBindStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ISlState } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import Constants from './common/Constants';
import { RectInfo } from '@ohos/basicutils';
import { ItemUtils } from '@ohos/componenthelper';
import { screenLockAniMgr, ScreenLockAniScene } from '../formAni/ScreenLockFormAniMgr';
import { ScreenLockSpaceAniData, spaceAniHelper, WidgetAnimState } from '@ohos/screenlockcommon/Index';
import ScreenLockFormUtil from './common/ScreenLockFormUtil';
import { SlFormStaticState } from './vm/SlFormStaticState';
import { AnyClock, CLOCK_DEFAULT_FOREGROUND_COLOR } from '../editsheet/models/AnyClock';
import { ScreenLockFormAniData } from '../formAni/ScreenLockFormAniData';
import { SlVisualControl } from '@ohos/screenlockcommon/src/main/ets/visual/SlVisualControl';
import { FormEnterEditCardEvent, FormCardSuccessEvent, FormOutputEventType } from '../common/command/Event';
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';

const TAG = 'ScreenLockFormPanel'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const COLOR_BLACK: string = '#ff000000';
const SINGLE_COLOR_RENDER_MODE: number = 1;
const PRF_KEY_REPORT_COUNT = 'formDataStateWeeklyReportCount';
const FORM_SIZE_SPACE_TWO: number = 2;
const PAD_FORM_PANEL_MAX_HEIGHT: number = 560;
const PHONE_FORM_PANEL_MARGIN_TOP: number = 64;
const DEVICE_WIDTH_SM: number = 600;
const GRID_PADDING: number = 16;
const DEVICE_WIDTH_MD: number = 840;
const DEVICE_GRID_PADDING_MD: number = 24;
const DEVICE_GRID_COUNT_MD: number = 8;
const DEVICE_GRID_USED_MD: number = 6;
const DEVICE_WIDTH_LG: number = 1440;
const DEVICE_GRID_PADDING_LG: number = 32;
const DEVICE_GRID_COUNT_LG: number = 12;
const DEVICE_GRID_USED_LG: number = 10;
const DEVICE_GRID_PADDING_SU: number = 40;
const COMPONENT_ID_SCREEN_LOCK_FORM = SlWidgetId.FORM;
const CLOCK_UP_DISTANCE: number = 39;
const DEFAULT_FORM_HEIGHT: number = 59;
const FOLD_HEIGHT_RATIO: number = 0.8;
const PAD_PORTRAIT_HEIGHT_RATIO: number = 0.6;
const ENABLE_DRAG_ARRAY: number[] = [EDIT_FORM_MODE_MAIN, EDIT_FORM_MODE_DETAIL, EDIT_FULL_MODE];
const UPDATE_THEME_DELAY: number = 1000;
const BLENDMODE_DESTINATION_IN: number = 6;

@Component
export default struct ScreenLockFormPanel {
  private longPressGesture?: () => void;
  private persistentId: number = 0;
  @Prop aestheticColorArgs?: AestheticColorArgs = new AestheticColorArgs();
  @Prop clockStrokeColor?: string = '';
  @Prop isLightWallpaper: boolean = false;
  @Prop formPositionY: number;
  @Prop mainColorType: ColorType = ColorType.LIGHT;
  @Prop bgEffect: BackgroundEffectOptions | undefined;
  @Link @Watch('onFormViewModelChange') formViewModel: ScreenLockFormViewModel;
  @Consume @Watch('onGridWidth') gridWidth: number;
  @State isNtfListCollapsed: boolean = ScreenLockFormPanelMeshConfig.isPanelVisible;
  @State isInEditMode: boolean = false;
  @State themeId: string = '';
  @State displayMode: number = NONE_EDIT_MODE;
  @State isZhLanguage: boolean = true;
  @Link @Watch('bindSheetChanged') isShowFormBindSheet: boolean;
  @Link screenProp: SCBScreenProperty;
  @State panelWidth: number = 0;
  @StorageLink('isPortrait') isPortrait: boolean = true;
  @Consume isEditClockUp: boolean;
  @State currentFormInfo: AppItemInfo = new AppItemInfo();
  @State currentAppName: string = '';
  @State currentCardItemInfoList: CardItemInfo[] = [];
  @State formWidth: number = 0;
  @State fontScale: DynamicFontSize = sFontScaleUtil.realDynamicSize;
  @State formGridWidthAmount: number = 4;
  @StorageProp('isClearInvalidCardsDone') isClearInvalidCardsDone: boolean = false;
  @State slFormAnimCtrl: WidgetAnimState | undefined = slStateHelper.getSlClockAnimState(); // 卡片组件动效状态管理

  @State slFormBindCtrl: SlClockBindState | undefined = slStateHelper.getSlClockBindState(); // 卡片组件UI样式状态管理
  @State slBindState?: ISlState = slStateHelper.getSlBindState();

  @State slFormStaticState: SlFormStaticState | undefined = slStateHelper.getSlFormStaticState(); // 卡片静态状态管理
  @State spaceAniOpt: ScreenLockSpaceAniData = spaceAniHelper.getSpaceAniFormState();

  @Link clockStyle: AnyClock;
  private isShowFormPanel: boolean = true;
  private themeName: string = '';
  @Consume formProxy: FormProxy | undefined;
  private displayModeListener: DisplayModeChangeListener = {
    onDisplayModeChange: (newMode) => {
      this.displayMode = newMode;
      let isEditMode: boolean = this.formViewModel.isInEditMode();
      // 进入编辑模式之后卡片可见性是true
      if (this.isInEditMode !== isEditMode) {
        this.isInEditMode = isEditMode;
        // 刷新卡片可见性
        this.updateFormPanelShow();
      }
      log.showInfo(`onDisplayModeChange ${this.displayMode}  ${this.isInEditMode}`);
    }
  }
  private screenWidthChangeCallback = () => {
    this.panelWidth = this.getPadPanelWidth();
  };

  bindSheetChanged(): void {
    let param: FormCenterViewParam = new FormCenterViewParam();
    param.formDisplayType = FormDisplayType.SCREEN_LOCK_CARD;
    param.openHighIndexView = true;
    param.viewHeight = this.getDefaultPanelHeight();
    param.viewMaxHeight = this.getFullPanelHeight();
    param.location = FormCenterLocation.SCREEN_LOCK;
    if (this.isShowFormBindSheet) {
      this.formProxy?.openFormCenter(param);
    } else {
      this.formProxy?.closeFormCenter();
    }
  }

  aboutToAppear() {
    log.showDebug('aboutToAppear');
    GlobalStatusCache.getInstance().subscribe(StatusCacheConst.SCREEN_WIDTH_KEY, this.screenWidthChangeCallback);
    this.isNtfListCollapsed = ScreenLockFormPanelMeshConfig.isPanelVisible;
    sEventManager.subscribe(FormPanelChange.PANEL_VISIBLE, this.onFormPanelVisibilityChange);
    this.panelWidth = this.getPadPanelWidth();
    let curLanguage: string = getContext().resourceManager.getConfigurationSync().locale;
    if (curLanguage.startsWith('en')) {
      this.isZhLanguage = false;
    }
    this.setFormPanelWidth();
  }

  aboutToDisappear() {
    log.showDebug('aboutToDisappear');
    // 如果bindSheet状态为true时灭屏需关闭半模态框  防止ScreenLockFormCard组件下树未关闭半模态框
    if (this.isShowFormBindSheet) {
      this.formProxy?.closeFormCenter();
    }
    GlobalStatusCache.getInstance().unsubscribe(StatusCacheConst.SCREEN_WIDTH_KEY, this.screenWidthChangeCallback);
    sEventManager.off(FormPanelChange.PANEL_VISIBLE, this.onFormPanelVisibilityChange);
  }

  /**
   * 计算纵向缩放中心
   * @param id string
   * @param screenHeightPx number
   * @returns number | string
   */
  private getScaleCenterY(id: string, screenHeightPx: number): number | string {
    let rectInfo: RectInfo = ItemUtils.getRectById(id);
    let height: number = px2vp(screenHeightPx);
    return height / 2 - rectInfo.top;
  }

  private onGridWidth(): void {
    this.setFormPanelWidth()
  }

  private setFormPanelWidth(): void {
    this.formWidth = this.clockStyle.getGridAmountWidth() * this.gridWidth;
    this.formGridWidthAmount = clockLayoutParam.gridParam.gridWidthAmount;
  }

  private getFullPanelHeight(): number {
    if (DeviceHelper.isFoldExpanded()) {
      return px2vp(this.screenProp.height) * FOLD_HEIGHT_RATIO;
    }
    if (DeviceHelper.isPadOr2in1PcType()) {
      return px2vp(this.screenProp.height) * (this.isPortrait ? PAD_PORTRAIT_HEIGHT_RATIO : FOLD_HEIGHT_RATIO);
    }
    return px2vp(this.screenProp.height) - PHONE_FORM_PANEL_MARGIN_TOP;
  }

  private getIncreasedHeight(): number {
    let increasedHeight: number = 0;
    if (!this.isZhLanguage) {
      if (sFontScaleUtil.fontScale === sFontScaleUtil.maxLockIconFontSize) {
        increasedHeight = 24
      } else if (sFontScaleUtil.fontScale > sFontScaleUtil.maxLockIconFontSize) {
        increasedHeight = 48
      }
    }
    if (sFontScaleUtil.fontScale > sFontScaleUtil.maxFontSize) {
      return 50 * (sFontScaleUtil.maxFontSize - 1) + increasedHeight;
    }
    return 50 * ((sFontScaleUtil.fontScale < 1 ? 0 :
      sFontScaleUtil.fontScale - 1)) + increasedHeight;
  }

  private getDefaultPanelHeight(): number {
    let screenHeight: number = px2vp(this.screenProp.height);
    let clockFormHeight: number = clockLayoutHelper.getWidgetSize().height +
    this.getIncreasedHeight() + this.formViewModel.getFormPanelHeight() *
    clockLayoutHelper.getLayoutGridWidth(this.isPortrait);
    let layoutHeight: number = clockLayoutHelper.getLayoutAmount(this.isPortrait, DeviceHelper.isFoldExpanded()).y;
    let clockPositionY: number = (layoutHeight - clockLayoutParam.gridParam.gridHeightAmount -
    this.formPositionY) * this.gridWidth
    let freeHeight: number = screenHeight - 104 - clockFormHeight - clockPositionY;
    let minPanelHeight: number = this.gridWidth * 2 + 122 + this.getIncreasedHeight();

    if (freeHeight >= minPanelHeight) {
      return freeHeight;
    }

    if (this.isShowFormBindSheet) {
      this.isEditClockUp = true;
    }
    let clockUpFreeHeight: number = screenHeight - CLOCK_UP_DISTANCE - clockFormHeight;
    if (clockUpFreeHeight >= minPanelHeight) {
      return clockUpFreeHeight;
    }

    let expectClockFormHeight: number = screenHeight - minPanelHeight - CLOCK_UP_DISTANCE;
    animateTo({
      curve: curves.interpolatingSpring(0, 1, 228, 30)
    }, () => {
      this.slBindState?.setSlState(SlBindStateType.SL_EDIT_CLOCK_UP_SCALE, expectClockFormHeight / clockFormHeight);
    });
    return minPanelHeight;
  }

  private getPadPanelWidth(): number {
    let width: number = px2vp(this.screenProp.width);
    let gridWidth: number = 0;
    if (width <= DEVICE_WIDTH_SM) {
      return width;
    } else if (width <= DEVICE_WIDTH_MD) {
      gridWidth = (width - DEVICE_GRID_PADDING_MD * 2 - GRID_PADDING *
        (DEVICE_GRID_COUNT_MD - 1)) / DEVICE_GRID_COUNT_MD;
      return gridWidth * DEVICE_GRID_USED_MD + (DEVICE_GRID_USED_MD - 1) * GRID_PADDING;
    } else if (width <= DEVICE_WIDTH_LG) {
      gridWidth = (width - DEVICE_GRID_PADDING_LG * 2 - GRID_PADDING *
        (DEVICE_GRID_COUNT_LG - 1)) / DEVICE_GRID_COUNT_LG;
    } else {
      gridWidth = (width - DEVICE_GRID_PADDING_SU * 2 - GRID_PADDING *
        (DEVICE_GRID_COUNT_LG - 1)) / DEVICE_GRID_COUNT_LG;
    }
    return gridWidth * DEVICE_GRID_USED_LG + (DEVICE_GRID_USED_LG - 1) * GRID_PADDING;
  }

  private onFormPanelVisibilityChange = (isFormPanelShow: boolean) => {
    if (this.isNtfListCollapsed !== isFormPanelShow) {
      this.isNtfListCollapsed = isFormPanelShow;
    }
    this.updateFormPanelShow();
    log.showInfo(`form panel show state ${isFormPanelShow}`);
  }

  private updateFormPanelShow(): void {
    // 通知列表收起状态或进入编辑，卡片显示
    let isFormShow = this.isNtfListCollapsed || this.isInEditMode;
    this.slFormStaticState?.setFormPanelShow(isFormShow);
    this.slFormStaticState?.setFormShowCount(this.formViewModel.getUsedCardSpace());
  }

  private onFormViewModelChange() {
    log.showInfo('onFormViewModelChange');
    this.setFormPanelWidth()
  }

  private isNeedShowFormPanel(): boolean {
    let isInMainMode = this.displayMode === NONE_EDIT_MODE;
    let isNeedShowOnMainPage = this.formViewModel.hasAddedCard() && this.isNtfListCollapsed;
    let isNeedShowOnEditPage = this.displayMode === EDIT_GUIDE_MODE || this.displayMode === EDIT_FULL_MODE ||
      this.displayMode === EDIT_FORM_MODE_MAIN || this.displayMode === EDIT_FORM_MODE_DETAIL ||
      this.displayMode === ENTER_OTHER_APP_BORDER_SHOW || this.displayMode === ENTER_OTHER_APP_BORDER_HIDE ||
      this.displayMode === EDIT_CLOCK_DRAG || this.displayMode === EDIT_FORM_DRAG;
    let isNeedShowFormPanel =
      ((this.isInEditMode && isNeedShowOnEditPage) || (isInMainMode && isNeedShowOnMainPage));
    if (this.isShowFormPanel !== isNeedShowFormPanel) {
      log.showInfo(`isNeedShowFormPanel: ${isNeedShowFormPanel}`)
      this.isShowFormPanel = isNeedShowFormPanel;
    }
    if (!isNeedShowFormPanel) {
      log.showInfo(`displayMode: ${this.displayMode}, hasAddedCard: ${this.formViewModel.hasAddedCard()}, isNtfListCollapsed: ${this.isNtfListCollapsed}`)
    }
    return isNeedShowFormPanel;
  }

  /**
   * 小卡片组件缩放
   *
   * @returns 缩放
   */
  private getFormScale(): ScaleOptions {
    let zoomRatio = this.slBindState?.getSlState(SlBindStateType.SL_ZOOM_RATIO);
    if (zoomRatio && zoomRatio > Constants.DEFAULT_ZOOM_RATIO) {
      let screenHeight: number = GlobalStatusCache.getInstance().
      getStatus(StatusCacheConst.SCREEN_HEIGHT_KEY, 0) as number;
      return {
        x: this.spaceAniOpt.getSpaceScale(),
        y: this.spaceAniOpt.getSpaceScale(),
        centerX: '50%',
        centerY: this.getScaleCenterY(SlWidgetId.FORM, screenHeight)
      };
    }
    if (this.slFormAnimCtrl?.isSceneAnimating()) {
      return {
        x: this.slFormAnimCtrl?.getStateValue(WBaseProperty.SCALE_X) as number,
        y: this.slFormAnimCtrl?.getStateValue(WBaseProperty.SCALE_Y) as number
      }
    }
    return {
      x: this.slFormBindCtrl?.getLayoutScale(),
      y: this.slFormBindCtrl?.getLayoutScale()
    }
  }

  private serviceCardAreaAccessText(): Resource {
    if ((this.displayMode === EDIT_GUIDE_MODE || this.displayMode === EDIT_FULL_MODE) && this.formPositionY > 0) {
      return $r('app.string.widgets_two_click_accessible');
    }
    return $r('app.string.Double_click_and_hold_accessibility');
  }

  private isServiceCardAreaAccess(): boolean {
    if ((this.displayMode === EDIT_GUIDE_MODE || this.displayMode === EDIT_FULL_MODE) && this.formPositionY > 0) {
      return true;
    }
    return false;
  }

  @Builder
  titleBuilder() {
    Text($r('app.string.add_form_to_desktop'))
      .draggable(false)
      .id(`${TAG}_text`)
      .textAlign(TextAlign.Start)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .maxLines(1)
      .fontSize($r('sys.float.ohos_id_text_size_headline8'))
      .minFontScale(sFontScaleUtil.minFontSize)
      .maxFontScale(sFontScaleUtil.maxFontSize)
      .fontColor($r('sys.color.ohos_id_color_text_primary'))
      .fontWeight(FontWeight.Bold)
      .offset({ y: 2 })
      .width('100%')
      .height('56vp')
  }

  build() {
    Column() {
      Stack() {
        if (this.isClearInvalidCardsDone && this.formViewModel.hasAddedCard()) {
          Stack() {
            ScreenLockFormComponent({
              displayMode: this.displayMode,
              mainColorType: this.mainColorType,
              formPositionY: this.formPositionY,
              formViewModel: this.formViewModel,
              sizeHeight: this.formViewModel.getFormPanelHeight(),
              formGridWidthAmount: this.formGridWidthAmount,
              themeId: this.themeId,
              themeName: this.themeName,
              bgEffect: this.bgEffect,
              isLightWallpaper: this.isLightWallpaper,
              aestheticColorArgs: this.aestheticColorArgs,
              clockStrokeColor: this.clockStrokeColor,
              formWidth: this.formWidth,
              longPressGesture: this.longPressGesture
            })
          }
          .accessibilityLevel('no')
          .hitTestBehavior(HitTestMode.Transparent)
          .visibility(this.isNeedShowFormPanel() ? Visibility.Visible : Visibility.Hidden)

          Stack() {
          }
          .width('100%')
          .height('100%')
          .hitTestBehavior(HitTestMode.None)
        }
      }
      .accessibilityLevel('no')
      .hitTestBehavior(HitTestMode.Transparent)
      .visibility(this.isNeedShowFormPanel() ? Visibility.Visible : Visibility.Hidden)
    }
    .accessibilityGroup(false)
    .accessibilityLevel(this.isServiceCardAreaAccess() ? 'yes' : 'no')
    .accessibilityText(ResUtils.getInnerString($r('app.string.service_form_area_accessible')))
    .accessibilityDescription(ResUtils.getInnerString($r('app.string.widgets_two_click_accessible')))
    .onClick((event?: ClickEvent) => {
      if ((this.displayMode === EDIT_GUIDE_MODE || this.displayMode === EDIT_FULL_MODE) && this.formPositionY > 0) {
        log.showInfo(`onClick displayMode: ${this.displayMode} formPositionY: ${this.formPositionY}`);
        let event = new FormEnterEditCardEvent(FormOutputEventType.ENTER_EDIT_CARD_EVENT, TAG);
        this.formViewModel.formAdapter?.getInvoker().onEvent(event);
        PerformanceMonitorUtil.reportLockscreenEditServiceWidgets();
      }
    })
    .width(this.formWidth)
    .height(this.isNeedShowFormPanel() ? this.formViewModel.getFormPanelHeight() * this.gridWidth : 0)
    .alignItems(HorizontalAlign.Start)
    .hitTestBehavior(HitTestMode.Transparent)
    .scale(this.getFormScale())
    .id(COMPONENT_ID_SCREEN_LOCK_FORM)
  }
}

class GridLayoutOptionRet {
  public static getGridLayoutOptions(formViewModel: ScreenLockFormViewModel): GridLayoutOptions {
    log.showInfo('GridLayoutOptionRet getGridLayoutOptions');
    return {
      onGetRectByIndex: (index: number): [number, number, number, number] => {
        let config: LockscreenFormConfig | undefined = formViewModel.formConfigs[index];
        if (!config) {
          return [-1, 1, -1, 1];
        }
        let rect: [number, number, number, number] = GridLayoutOptionRet.getFormItemRect(formViewModel, config);
        log.showInfo(`onGetRectByIndex index: ${index}, rect: [${rect}]`);
        return rect;
      },
      // 大小规则的GridItem在Grid中占的行数和列数，只支持占1行1列即[1, 1]
      regularSize: [1, 1]
    };
  }

  private static getFormItemRect(formViewModel: ScreenLockFormViewModel,
    config: LockscreenFormConfig): [number, number, number, number] {
    if (formViewModel.isDoubleLineLayout()) {
      return [config.positionY, config.positionX - 1, 1, config.dimensionX];
    } else {
      return [config.positionY, config.positionX, 1, config.dimensionX];
    }
  }
}

@Component
struct ScreenLockFormComponent {
  private longPressGesture?: () => void;
  @Link displayMode: number;
  @Prop mainColorType: ColorType;
  @Prop formPositionY: number;
  @Consume isEdited: boolean;
  @Consume gridWidth: number;
  @Link @Watch('onFormConfigChange') formViewModel: ScreenLockFormViewModel;
  @State themeId: string = '';
  @Prop bgEffect: BackgroundEffectOptions | undefined;
  @Prop sizeHeight: number;
  @Link formGridWidthAmount: number;
  @Prop formWidth: number;
  @Prop aestheticColorArgs?: AestheticColorArgs = new AestheticColorArgs();
  @Prop clockStrokeColor?: string = '';
  @Prop isLightWallpaper: boolean = false;
  @Consume @Watch('onFormDrag') holderInfo: FormPlaceHolderInfo;
  @State layoutOptions: GridLayoutOptions = GridLayoutOptionRet.getGridLayoutOptions(this.formViewModel);
  private themeName: string = '';
  private needReloadCards: LockscreenFormConfig[] = [];
  private doReloadTaskId: number | null = null;
  private updateThemeCfgTaskId: number | null = null;

  private onFormDrag(): void {
    if (this.holderInfo.isDrag) {
      this.formViewModel.handler?.handleDrag(this.formViewModel, this.holderInfo,
        this.formViewModel.supportFormPositions);
    }
  }

  private onFormConfigChange(): void {
    // 触发网格刷新
    log.showInfo('onFormConfigChange');
    this.layoutOptions = GridLayoutOptionRet.getGridLayoutOptions(this.formViewModel);
    if (!this.formViewModel.formComponentOpacity) {
      log.showInfo('this.formViewModel.formComponentOpacity is false');
    } 
  }

  aboutToAppear() {
    log.showInfo('ScreenLockFormComponent aboutToAppear');
    this.handleReportData();
  }

  aboutToDisappear() {
    log.showInfo('ScreenLockFormComponent aboutToDisappear');
  }

  private handleReportData() {
    if (!this.formViewModel.isScreenLockMainPage()) {
      return;
    }
    const date: Date = new Date();
    let sunDay: number = 0;
    ScreenLockPreferencesUtil.get(GlobalContext.getContext(), PRF_KEY_REPORT_COUNT, 0).then((value) => {
      let formDataStateWeeklyReportCount: number = value as number;
      // 非周日不打点
      if (!date || date.getDay() !== sunDay) {
        if (formDataStateWeeklyReportCount !== 0) {
          ScreenLockPreferencesUtil.put(GlobalContext.getContext(), PRF_KEY_REPORT_COUNT, 0);
        }
        return;
      }
      // 若周日已打点，则不重复打点
      if (formDataStateWeeklyReportCount > 0) {
        return;
      }
      ScreenLockPreferencesUtil.put(GlobalContext.getContext(), 'formDataStateWeeklyReportCount', 1);
      this.doReportFormData();
    })
  }

  private doReportFormData() {
    let index: number = 1;
    let formNum: number = 0;
    let dimensionNum: number = 0;
    let recommendLocation: string = '';
    let paramsReportList: ScreenLockFormDataReportParamsState[] = [];
    for (let i = 0; i < this.formViewModel.formConfigs.length; i++) {
      if (this.formViewModel.formConfigs[i].dimensionX === 0) {
        continue;
      }
      if (this.formViewModel.formConfigs[i].dimensionX === FORM_SIZE_SPACE_TWO) {
        recommendLocation = `${index},${index + 1}`
        index += FORM_SIZE_SPACE_TWO;
      } else {
        recommendLocation = `${index}`
        index++;
      }
      formNum++;
      dimensionNum += this.formViewModel.formConfigs[i].dimensionX;
      let formItem: CardItemInfo = this.formViewModel.formConfigs[i].formInfo;
      let params: ScreenLockFormDataReportParamsState = {
        FORMID: formItem.cardId,
        PACKAGENAME: (formItem.bundleName as string),
        CARDDIMENSION: formItem.cardDimension.toString(),
        MODULENAME: (formItem.moduleName as string),
        FORMNAME: (formItem.cardName as string),
        FORMNUM: 0,
        RECOMMENDLOCATION: recommendLocation,
        DIMENSIONNUM: 0
      }
      paramsReportList.push(params)
    }
    for (let i = 0; i < paramsReportList.length; i++) {
      paramsReportList[i].FORMNUM = formNum;
      paramsReportList[i].DIMENSIONNUM = dimensionNum;
      HiSysEventUtil.reportScreenLockFormDataState(paramsReportList[i]);
    }
  }

  private reloadScreenLockForm(item: LockscreenFormConfig): void {
    if (this.doReloadTaskId !== null) {
      clearTimeout(this.doReloadTaskId);
    }
    log.showInfo(`add reload form id ${item.formInfo.cardId}`);
    this.needReloadCards.push(item);
    this.doReloadTaskId = setTimeout(() => {
      this.formViewModel.reloadScreenLockForm(this.needReloadCards, this.themeId, this.themeName);
      this.doReloadTaskId = null;
      this.needReloadCards = [];
    }, 50)
  }

  private updateThemeCfg(newFormId: string): void {
    if (this.displayMode !== NONE_EDIT_MODE) {
      log.showInfo('not in host')
      return;
    }
    if (this.updateThemeCfgTaskId !== null) {
      clearTimeout(this.updateThemeCfgTaskId);
    }
    log.showInfo(`update config form id ${newFormId}`);
    this.updateThemeCfgTaskId = setTimeout(() => {
      this.formViewModel.updateThemeCfgByFormConfigs();
      this.updateThemeCfgTaskId = null;
    }, UPDATE_THEME_DELAY)
  }

  /**
   * 判断item的positionY不能直接取，因为key值不变的情况下，item不会刷新，因此需要从formConfigs中获取新的item
   * @param item
   * @returns 是否显示该卡片
   */
  private showGridItem(item: LockscreenFormConfig): boolean {
    const formConfigKey: string = ScreenLockFormUtil.getFormConfigKey(item);
    const actualItem: LockscreenFormConfig | undefined =
      this.formViewModel.formConfigs.find(formItem => ScreenLockFormUtil.getFormConfigKey(formItem) === formConfigKey);
    if (actualItem === undefined) {
      return false;
    }
    log.showInfo(`actualItem.positionY ${actualItem.positionY} formPositionY ${this.formPositionY}}`);
    return item.dimensionX !== 0 && actualItem.positionY < this.formPositionY;
  }

  build() {
    Grid(undefined, this.layoutOptions) {
      ForEach(this.formViewModel.formConfigs, (item: LockscreenFormConfig, index: number) => {
        if (this.showGridItem(item)) {
          GridItem() {
            ScreenLockFormCard({
              formKey: ScreenLockFormUtil.getFormConfigKey(item),
              formHeight: this.gridWidth - 24,
              formWidth: this.gridWidth * item.dimensionX - 24,
              cardInfo: item.formInfo,
              formViewModel: this.formViewModel,
              bgEffect: this.bgEffect,
              radius: this.gridWidth / 2 - 12,
              onAcquiredCallback: (newFormId: string) => {
                if (item.formInfo.cardId !== newFormId) {
                  item.formInfo.cardId = newFormId;
                  this.updateThemeCfg(newFormId);
                }
              },
              onAcquiredFailedCallback: () => {
                if (this.formViewModel.isInEditMode()) {
                  this.isEdited = true;
                }
                this.reloadScreenLockForm(item);
              },
              displayMode: this.displayMode,
              mainColorType: this.mainColorType,
              themeId: this.themeId,
              themeName: this.themeName,
              isLightWallpaper: this.isLightWallpaper,
              aestheticColorArgs: this.aestheticColorArgs,
              clockStrokeColor: this.clockStrokeColor,
              formPositionY: this.formPositionY
            })
          }
          .parallelGesture(GestureGroup(GestureMode.Exclusive,
            LongPressGesture({ repeat: false, duration: 500 })
              .onAction((event?: GestureEvent) => {
                this.longPressGesture?.();
              })
          ))
          .accessibilityLevel('no')
          .opacity(this.formViewModel.formComponentOpacity)
          .width(this.gridWidth * item.dimensionX - 12)
          .height(this.gridWidth - 12)
        }
      }, (item: LockscreenFormConfig, index: number) => ScreenLockFormUtil.getFormConfigKey(item))
    }
    .direction(Direction.Ltr)
    .columnsTemplate(this.formViewModel.isDoubleLineLayout() ? '1fr 1fr' : '1fr 1fr 1fr 1fr')
    .rowsTemplate(this.sizeHeight === 1 ? '1fr' : '1fr 1fr')
    .width(this.formWidth)
    .height(this.sizeHeight * this.gridWidth)
    .clip(false)
    .transition(TransitionEffect.OPACITY.animation({
      duration: 150,
      curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1)
    }))
  }
}

@Component
struct ScreenLockFormCard {
  @Link @Watch('onFormConfigChange') formViewModel: ScreenLockFormViewModel;
  @Prop formKey: string;
  @Prop formHeight: number;
  @Prop formWidth: number;
  @Prop radius: number;
  @Prop cardInfo: CardItemInfo;
  @Link displayMode: number;
  @Prop mainColorType: ColorType;
  @Consume isEdited: boolean;
  @Consume gridWidth: number;
  @State themeId: string = '';
  @Prop aestheticColorArgs?: AestheticColorArgs = new AestheticColorArgs();
  @Prop bgEffect: BackgroundEffectOptions | undefined;
  @Prop clockStrokeColor?: string = '';
  @Prop formPositionY: number;
  @Prop isLightWallpaper: boolean = false;
  @State isBackgroundVisible: boolean = false;
  @State isContentVisible: boolean = true;
  @State formScale: number = 1;
  @Consume holderInfo: FormPlaceHolderInfo;
  @State slBindState?: ISlState = slStateHelper.getSlBindState();
  @State translateX: number = 0;
  @State translateY: number = 0;

  private positionX: number = 0;
  private positionY: number = 0;

  @State slClockBindCtrl: SlClockBindState | undefined = slStateHelper.getSlClockBindState(); // 时钟组件UI样式状态管理
  @State foregroundBrightArgs?: SlVisualArgs =
    SlVisualControl.getInstance().getVisualArgs(SlPositionType.SL_FORM_FOREGROUND);
  @State panelBrightArgs?: SlVisualArgs = SlVisualControl.getInstance().getVisualArgs(SlPositionType.SL_FORM_PANEL);
  private enableEffect: boolean = SlVisualControl.getInstance().getEnable(CcmOption.EFFECT, SlAreaType.FORM);
  private enableBright: boolean = SlVisualControl.getInstance().getEnable(CcmOption.BRIGHT, SlAreaType.FORM);
  private enableSolid: boolean = SlVisualControl.getInstance().getEnable(CcmOption.SOLID, SlAreaType.FORM);
  private enableAllSolid: boolean = SlVisualControl.getInstance().getEnable(CcmOption.SOLID);

  private dragSnapshot?: PixelMap;
  private themeName: string = '';
  private keyguardCardDarkBgOption: BackgroundBrightnessOptions = BrightnessOptionUtils.keyguardCardBackgroundDarkOption;
  private keyguardCardLightBgOption: BackgroundBrightnessOptions = BrightnessOptionUtils.keyguardCardBackgroundLightOption;
  private keyguardTimeDarkOption: BackgroundBrightnessOptions = BrightnessOptionUtils.keyguardTimeDarkOption;
  private keyguardTimeLightOption: BackgroundBrightnessOptions = BrightnessOptionUtils.keyguardTimeLightOption;
  private brightColor: ResourceColor = BrightnessOptionUtils.brightColor;
  private eventMgr: EventManager = EvtBus.createEventManager();
  private isNotifyInvisibled = false;
  private formOpacity: number = 1;
  public onAcquiredFailedCallback: Function = (): void => {
  };
  public onAcquiredCallback: Function = (newFormId: string): void => {
  };
  private currentFormId: string = '';
  private formComponentBuilder: FormComponentBuilder = {
    id: FormCommonUtil.transformCardId(this.cardInfo.cardId),
    name: this.cardInfo.cardName,
    bundle: this.cardInfo.bundleName,
    ability: this.cardInfo.abilityName,
    module: this.cardInfo.moduleName,
    dimension: this.cardInfo.cardDimension,
    renderingMode: SINGLE_COLOR_RENDER_MODE,
    want: ScreenLockFormViewModel.getFromWant(),
  };

  private onFormConfigChange() {
    let formConfig: LockscreenFormConfig | undefined =
      ScreenLockFormUtil.getFormConfigByKey(this.formViewModel.formConfigs, this.formKey);
    if (formConfig) {
      let diffX: number = this.positionX - formConfig.positionX;
      let diffY: number = this.positionY - formConfig.positionY;
      this.doSwitchAnimation(diffX, diffY);
      this.positionX = formConfig.positionX;
      this.positionY = formConfig.positionY;
    }
  }

  private doSwitchAnimation(diffX: number, diffY: number) {
    log.showInfo(`ScreenLockFormCard doSwitchAnimation ${diffX}, ${diffY}`);
    if (this.slBindState && (diffX !== 0 || diffY !== 0)) {
      let gridWidth: number = this.slBindState.getSlState(SlBindStateType.SL_GRID_WIDTH) as number;
      this.translateX = gridWidth * diffX;
      this.translateY = gridWidth * diffY;
      animateTo({
        curve: curves.interpolatingSpring(0, 1, 228, 30),
      }, () => {
        this.translateX = 0;
        this.translateY = 0;
      })
    }
  }

  aboutToAppear() {
    let formConfig: LockscreenFormConfig | undefined =
      ScreenLockFormUtil.getFormConfigByKey(this.formViewModel.formConfigs, this.formKey);
    this.positionX = formConfig ? formConfig.positionX : 0;
    this.positionY = formConfig ? formConfig.positionY : 0;
    log.showInfo(`ScreenLockFormCard aboutToAppear ${this.cardInfo.cardName} positionX ${this.positionX} positionY ${this.positionY}`);
    this.eventMgr.on(ScreenOnOffEvent, this.onScreenOnOffEvent);
  }

  aboutToDisappear() {
    log.showInfo('ScreenLockFormCard aboutToDisappear ' + this.currentFormId);
    Trace.end(Trace.CORE_METHOD_DELETE_SCREEN_LOCK_FORM);
    this.eventMgr.offAll();
  }

  private handleDragStart(event: DragEvent): DragItemInfo {
    let formConfig: LockscreenFormConfig | undefined =
      ScreenLockFormUtil.getFormConfigByKey(this.formViewModel.formConfigs, this.formKey);
    if (!formConfig) {
      log.showWarn('handleDragStart invalid form config');
      return {};
    }
    this.holderInfo = FormPlaceHolderInfo.buildForm(true, formConfig, this.holderInfo);
    this.isContentVisible = true;
    this.slBindState?.setSlState(SlBindStateType.IS_FORM_DRAG_NOT_DROP, true);
    animateTo({
      duration: 300,
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
    }, () => {
      this.formScale = 1.05;
    })

    //上报卡片编辑拖拽事件
    let cardUEItem: CardItemUEInfo = {
      formId: this.holderInfo.dragForms?.formInfo.cardId.toString(),
      packageName: this.holderInfo.dragForms?.formInfo.bundleName,
      cardDimension: this.holderInfo.dragForms?.formInfo.cardDimension.toString(),
      moduleName: this.holderInfo.dragForms?.formInfo.moduleName,
      formName: this.holderInfo.dragForms?.formInfo.description,
      positionX: this.holderInfo.positionX,
      positionY: this.holderInfo.positionY,
      newX: this.holderInfo.newX,
      newY: this.holderInfo.newY
    };
    PerformanceMonitorUtil.reportLockscreenEditCardDrag(cardUEItem, Constants.SCREEN_LOCK_EDIT_CARD_DRAG);
    let key: string = `${this.holderInfo.dragForms?.formInfo.cardName}_${this.holderInfo.dragForms?.formInfo.tempId}`;
    this.formViewModel.editStatusBeforeDrag = screenLockInnerStateManager.currentState;
    screenLockAniMgr.prepareAnimation(ScreenLockAniScene.INNER, key)?.setSnapshot(this.dragSnapshot).
    setWidth(this.formWidth).setHeight(this.formHeight).setRadius(this.radius).setGridWidth(this.gridWidth).
    setDimensionX(formConfig.dimensionX);
    screenLockInnerStateManager.onEnterFullEditor(ScreenLockState.THEME_EDITOR_FORM_DRAG);
    let dragInfo: DragItemInfo = {
      pixelMap: this.dragSnapshot,
      extraInfo: new DragExtraInfo(DragDataType.FOLDER).setRadius(this.radius).setBlurStyle(BlurStyle.Thin).toString()
    };
    return dragInfo;
  }

  private onScreenOnOffEvent = (event: ScreenOnOffEvent): void => {
    if (!this.currentFormId || !this.formViewModel.isScreenLockMainPage()) {
      return;
    }
    this.notifyVisibleStateChange(this.currentFormId, event.isScreenOn());
    this.isContentVisibleChange(event);
  }

  private isContentVisibleChange(event: ScreenOnOffEvent): void {
    this.isContentVisible = true;
    if (!event.isScreenOn()) {
      let result = new FormCardSuccessEvent(FormOutputEventType.FORM_CARD_SUCCESS_EVENT, TAG);
      this.formViewModel.formAdapter?.getInvoker().onEvent(result);
    }
  }

  private notifyVisibleStateChange(formId: string, isScreenOn: boolean): void {
    log.showInfo(`formHost notifyVisibleStateChange ${formId}, isScreenOn ${isScreenOn}`);
    let formIdList: string[] = [];
    formIdList.push(formId);
    if (isScreenOn) {
      this.notifyVisible(formIdList);
      return;
    }
    this.notifyInVisible(formIdList);
  }

  private notifyVisible(formIds: Array<string>): void {
    try {
      formHost.notifyVisibleForms(formIds, (error: Base.BusinessError) => {
        if (error) {
          log.showError(`notify visible error, code: ${error.code}, message: ${error.message}`);
          return;
        }
        log.showInfo(`formHost notifyVisibleForms success ${formIds}`);
      });
      this.isNotifyInvisibled = false;
    } catch (error) {
      log.showError('notifyVisibleForms meet some error');
    }
  }

  private notifyInVisible(formIds: Array<string>): void {
    try {
      formHost.notifyInvisibleForms(formIds, (error: Base.BusinessError) => {
        if (error) {
          log.showError(`notify inVisible error, code: ${error.code}, message: ${error.message}`);
          return;
        }
        log.showInfo(`formHost notifyInvisibleForms success ${formIds}`);
      });
      this.isNotifyInvisibled = true;
    } catch (error) {
      log.showError('notifyInvisibleForms meet some error');
    }
  }

  private getChangeColor(): ResourceColor | undefined {
    return BrightnessOptionUtils.changeColor(this.clockStrokeColor) ?? this.brightColor;
  }

  private getMirrorAlpha(): number {
    const isChangeColor = slStateHelper.getSlClockStaticState()?.getChangeColorState();
    if (!isChangeColor) {
      return 1;
    }
    return 1;
  }

  // private getBrightnessOption(): BrightnessOptions | undefined {
  //   if (!this.enableBright || this.clockStrokeColor === COLOR_BLACK) {
  //     return undefined;
  //   }
  //   if (this.clockStrokeColor !== CLOCK_DEFAULT_FOREGROUND_COLOR) {
  //     return this.isLightWallpaper ?
  //       BrightnessOptionUtils.keyguardTimeDarkOptionForFillColor :
  //       BrightnessOptionUtils.keyguardTimeLightOptionForFillColor;
  //   }
  //   return this.isLightWallpaper ? this.keyguardTimeDarkOption : this.keyguardTimeLightOption;
  // }

  private getBrightnessOption(): BackgroundBrightnessOptions | undefined {
    if (!this.enableBright || this.clockStrokeColor === COLOR_BLACK) {
      return undefined;
    }
    if (this.clockStrokeColor !== CLOCK_DEFAULT_FOREGROUND_COLOR) {
      return this.isLightWallpaper ?
      BrightnessOptionUtils.keyguardTimeDarkOptionForFillColor :
      BrightnessOptionUtils.keyguardTimeLightOptionForFillColor;
    }
    return this.isLightWallpaper ? this.keyguardTimeDarkOption : this.keyguardTimeLightOption;
  }


  // private getBgBrightnessOption(): BrightnessOptions  | undefined {
  //   if (!this.enableBright) {
  //     return undefined;
  //   }
  //   return this.isLightWallpaper ? this.keyguardCardDarkBgOption : this.keyguardCardLightBgOption;
  // }

  private getBgBrightnessOption(): BackgroundBrightnessOptions | undefined {
    if (!this.enableBright) {
      return undefined;
    }
    return this.isLightWallpaper ? this.keyguardCardDarkBgOption : this.keyguardCardLightBgOption;
  }

  private getFormBackgroundVisible(): Visibility {
    return this.isBackgroundVisible ? Visibility.Visible : Visibility.Hidden;
  }

  private getFormOpacity(): number {
    let formOpacity: number = 1;
    let formConfig: LockscreenFormConfig | undefined =
      ScreenLockFormUtil.getFormConfigByKey(this.formViewModel.formConfigs, this.formKey);
    if (formConfig) {
      let formId: string = `${formConfig.formInfo.cardName}_${formConfig.formInfo.tempId}`;
      screenLockAniMgr.aniDataArrayMap.forEach((formDataArray: ScreenLockFormAniData[]) => {
        formDataArray.forEach((formData: ScreenLockFormAniData) => {
          if (formData.id === formId) {
            formOpacity = 0;
          }
        })
      })
    }
    if (formConfig === this.holderInfo.dragForms) {
      formOpacity = (this.holderInfo.isVisible ?? true) ? 1 : 0;
    }
    if (this.formOpacity !== formOpacity) {
      log.showInfo(`getFormOpacity formOpacity: ${formOpacity}, cardName: ${formConfig?.formInfo.cardName}, holderInfoVisible: ${this.holderInfo.isVisible}`)
      this.formOpacity = formOpacity;
    }
    return formOpacity;
  }

  private isDragEnable(): boolean {
    return this.displayMode === EDIT_FULL_MODE || this.displayMode === EDIT_FORM_MODE_MAIN ||
      this.displayMode === EDIT_FORM_MODE_DETAIL
  }

  private getFormCardId(): string {
    let formConfig: LockscreenFormConfig | undefined =
      ScreenLockFormUtil.getFormConfigByKey(this.formViewModel.formConfigs, this.formKey);
    if (!formConfig) {
      return TAG;
    }
    let positionX: number = formConfig.positionX;
    let positionY: number = formConfig.positionY;
    return `${TAG}_${positionX}_${positionY}`;
  }

  private isCardEnable(): boolean {
    return this.displayMode === NONE_EDIT_MODE;
  }

  private getBackgroundColor(): ResourceColor | undefined {
    if (this.enableSolid) {
      return this.panelBrightArgs?.getSolidColor();
    }
    if (!this.enableBright) {
      return this.panelBrightArgs?.getBrightnessColor(this.isLightWallpaper);
    }
    return this.brightColor;
  }

  private getForegroundColor(): ResourceColor | undefined {
    if (this.enableAllSolid) {
      if (this.clockStrokeColor !== CLOCK_DEFAULT_FOREGROUND_COLOR) {
        return BrightnessOptionUtils.changeRgb(this.clockStrokeColor);
      }
      return this.foregroundBrightArgs?.getSolidColor();
    }
    if (!this.enableBright) {
      if (this.clockStrokeColor !== CLOCK_DEFAULT_FOREGROUND_COLOR) {
        return BrightnessOptionUtils.changeRgb(this.clockStrokeColor);
      }
      return this.foregroundBrightArgs?.getBrightnessColor(this.isLightWallpaper);
    }
    return BrightnessOptionUtils.changeColor(this.clockStrokeColor) ?? this.brightColor;
  }

  private serviceCardAccessDescription(): string {
    if (this.displayMode === EDIT_GUIDE_MODE && this.formPositionY > 0) {
      return '';
    }
    return ResUtils.getInnerString($r('app.string.Double_click_and_hold_accessibility'));
  }

  build() {
    RelativeContainer() {
      Stack() {
        Stack() {
          Column() {
          }
          .backgroundEffect(this.enableEffect && this.enableBright ? this.bgEffect : undefined)
          .width('100%')
          .height('100%')

          Column() {
          }
          .width('100%')
          .height('100%')
          .backgroundColor(this.getBackgroundColor())
          .backgroundBrightness(this.getBgBrightnessOption())
        }
      }
      .accessibilityLevel('no-hide-descendants')
      .visibility(this.getFormBackgroundVisible())
      .margin({
        top: LengthMetrics.vp(6),
        bottom: LengthMetrics.vp(6),
        start: LengthMetrics.vp(6),
        end: LengthMetrics.vp(6)
      })
      .borderRadius(this.gridWidth - 12)
      .clip(true)

      Stack({ alignContent: Alignment.TopEnd }) {
        Stack() {
          FormComponent(this.formComponentBuilder)
            .width(
            this.formWidth)
            .height(this.formHeight)
            .scale({
              x: 1,
              y: 1
            })
            .enabled(this.isCardEnable())
            .borderRadius(this.radius)
            .onAcquired((form: FormCallbackInfo) => {
              log.showInfo(`FormComponent card id is: ${form.idString}`);
              Trace.end(Trace.CORE_METHOD_ADD_SCREEN_LOCK_FORM);
              this.currentFormId = String(form.idString);
              this.onAcquiredCallback(this.currentFormId);
              this.formViewModel.registerRouterProxy(String(form.idString));
            })
            .obscured([])
            .onError((error) => {
              log.showError(`FormComponent error msg: ${error.msg}`);
              this.onAcquiredFailedCallback();
            })
            .onUninstall((id: FormCallbackInfo) => {
              log.showError(`FormComponent uninstall: ${id}`);
              this.onAcquiredFailedCallback();
            })
            .onLoad(() => {
              this.isBackgroundVisible = true;
              if (this.formViewModel.isInEditMode()) {
                this.isEdited = true;
              }
              let event = new FormCardSuccessEvent(FormOutputEventType.FORM_CARD_SUCCESS_EVENT, TAG);
              this.formViewModel.formAdapter?.getInvoker().onEvent(event);
              log.showInfo(`onLoad success, currentId: ${this.currentFormId}`);
            })
            .accessibilityLevel('yes')
            .onRouter(() => {
              const bundleName = this.cardInfo?.bundleName as string;
              const dimension = this.cardInfo?.cardDimension as number;
              const cardName = this.cardInfo?.cardName as string;
              PerformanceMonitorUtil.reportScreenLockJumpAppParams(cardName + ';' + dimension.toString(), bundleName);
            })
        }
        .accessibilityLevel('yes')
        .accessibilityText(this.cardInfo.appName)
        .visibility(this.isContentVisible ? Visibility.Visible : Visibility.Hidden)
        .hitTestBehavior(HitTestMode.Transparent)
        .id(this.getFormCardId())
        .size({
          height: '100%',
          width: '100%'
        })
        .scale({
          x: this.formScale,
          y: this.formScale
        })
        .onTouch((event: TouchEvent) => {
          if (!this.isDragEnable()) {
            return;
          }
          if (event.type === TouchType.Down) {
            componentSnapshot.get(this.getFormCardId()).then((snapshot: PixelMap) => {
              this.dragSnapshot = snapshot;
              PixelMapUtil.addName(snapshot, 'ScreenLockFormPanel_onTouch');
            })
            animateTo({
              curve: curves.interpolatingSpring(0, 0, 240, 28),
            }, () => {
              this.formScale = 0.95;
            })
          } else if (event.type === TouchType.Up) {
            animateTo({
              curve: curves.interpolatingSpring(0, 0, 240, 28),
            }, () => {
              this.formScale = 1;
            })
          }
        })
        .draggable(this.isDragEnable())
        .dragPreview({
          pixelMap: this.dragSnapshot
        })
        .onPreDrag((status: PreDragStatus) => {
          log.showInfo(`pre drag status: ${status}`);
          if (status === PreDragStatus.PREVIEW_LIFT_STARTED) {
            log.showInfo('set content invisible');
            this.isContentVisible = false;
          } else if (status === PreDragStatus.PREVIEW_LANDING_FINISHED) {
            this.isContentVisible = true;
          }
        })
        .onDragStart((event: DragEvent) => {
          return this.handleDragStart(event);
        })
        .onDragEnd(() => {
          if (this.slBindState?.getSlState(SlBindStateType.IS_FORM_DRAG_NOT_DROP)) {
            let key: string =
              `${this.holderInfo.dragForms?.formInfo.cardName}_${this.holderInfo.dragForms?.formInfo.tempId}`;
            screenLockAniMgr.cancelAnimation(ScreenLockAniScene.INNER, key);
            this.holderInfo.isDrag = false;
            this.holderInfo.dragForms = undefined;
            this.slBindState?.setSlState(SlBindStateType.IS_FORM_DRAG_NOT_DROP, false);
            screenLockInnerStateManager.onEnterFullEditor(this.formViewModel.editStatusBeforeDrag);
          }
        })

        Column() {
        }
        .hitTestBehavior(HitTestMode.Transparent)
        .useEffect(this.clockStrokeColor !== COLOR_BLACK && this.enableEffect)
        .width('100%')
        .height('100%')
        .blendMode(6)
        .accessibilityLevel('no')

        Column() {
        }
        .hitTestBehavior(HitTestMode.Transparent)
        .width('100%')
        .height('100%')
        // .blendMode(!this.enableBright || this.enableSolid || this.clockStrokeColor === COLOR_BLACK ?
        //   BLENDMODE_DESTINATION_IN : BlendMode.NORMAL)
        .blendMode(!this.enableBright || this.enableSolid || this.clockStrokeColor === COLOR_BLACK ?
          BLENDMODE_DESTINATION_IN : BlendMode.SRC_OVER)
        .backgroundColor(this.getForegroundColor())
        .backgroundBrightness(this.getBrightnessOption())
        .accessibilityLevel('no')

        if (this.clockStrokeColor !== CLOCK_DEFAULT_FOREGROUND_COLOR &&
          this.clockStrokeColor !== COLOR_BLACK && this.enableBright) {
          Column() {
          }
          .hitTestBehavior(HitTestMode.Transparent)
          .width('100%')
          .height('100%')
          .backgroundColor(this.getForegroundColor())
          // .backgroundBrightnessInternal(BrightnessOptionUtils.keyguardSecondBrightnessOption)
          .backgroundBrightness(BrightnessOptionUtils.keyguardSecondBrightnessOption)
          .accessibilityLevel('no')
        }
      }
      .padding({
        top: LengthMetrics.vp(6),
        end: LengthMetrics.vp(6),
        bottom: LengthMetrics.vp(6),
        start: LengthMetrics.vp(6)
      })
      .blendMode(1000)

      if (this.formViewModel.getIsDeletingForm()) {
        this.removeBtnBuilder()
      }
    }
    .accessibilityLevel('no')
    .opacity(this.getFormOpacity())
    .parallelGesture(
      GestureGroup(GestureMode.Parallel,
        LongPressGesture({ repeat: false, duration: 300 })
          .onAction(() => {
            if (this.isDragEnable()) {
              vibratorMgr.startVibration();
            }
          })
      )
    )
    .translate({
      x: this.translateX,
      y: this.translateY
    })
  }

  /**
   * 卡片移除按钮
   */
  @Builder
  removeBtnBuilder() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
      }
      .borderRadius('9vp')
      .width('100%')
      .height('100%')
      .blur(40, undefined, { disableSystemAdaptation: true })

      Image($r('app.media.ic_public_list_remove'))
        .width(20)
        .height(20)
        .draggable(false)
    }
    .id('card_remove_button')
    .width(20)
    .height(20)
    .alignRules({
      top: { anchor: SlWidgetId.ROOT_ID, align: VerticalAlign.Top },
      right: { anchor: SlWidgetId.ROOT_ID, align: HorizontalAlign.End }
    })
    .onClick((event) => {
      log.showWarn('ScreenLockFormComponent delete onClick');
      Trace.start(Trace.CORE_METHOD_DELETE_SCREEN_LOCK_FORM);
      let formConfig: LockscreenFormConfig | undefined =
        ScreenLockFormUtil.getFormConfigByKey(this.formViewModel.formConfigs, this.formKey);
      if (formConfig) {
        this.isBackgroundVisible = false;
        this.isEdited = true;
        this.formViewModel.deleteScreenLockForm(formConfig, this.themeId, this.themeName);
        AccessibilityUtil.sendAccessibility(this.getDeletedCardName(formConfig))
      }
    })
    .responseRegion(AccessibilityUtil.isAccessibilityMode() ? { x: -20, y: 20, width: '400%', height: '400%' } :
      { x: 0, y: 0, width: '200%', height: '200%'})
    .accessibilityLevel('yes')
    .accessibilityGroup(true)
    .accessibilityText(ResUtils.getInnerString($r('app.string.service_form_delete_button_accessible')))
    .accessibilityDescription(ResUtils.getInnerString($r('app.string.widgets_two_click_accessible')))
  }

  private getDeletedCardName(formConfig: LockscreenFormConfig): string {
    try {
      if (formConfig.formInfo.appName) {
        return getContext(this)
          .resourceManager
          .getStringSync($r('app.string.card_deleted'), formConfig.formInfo.appName);
      } else {
        return getContext(this).resourceManager.getStringSync($r('app.string.card_deleted'), '');
      }
    } catch (e) {
      log.showError(`getDeletedCardName failed, Code is ${e.code}, message is ${e.message}`);
      return '';
    }
  }
}
