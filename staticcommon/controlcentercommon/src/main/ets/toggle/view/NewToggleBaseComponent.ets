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

import lottie, { AnimationItem } from '@ohos/lottie';
import {
  ColorMetrics,
  curves,
  LengthMetrics,
  LengthUnit,
  UIContext,
  MeasureText,
} from '@kit.ArkUI';
import { KeyCode } from '@kit.InputKit';
import {
  AnimateToScheduleUtils,
  DomainName,
  LogDomain,
  LogHelper,
  TraceUtil,
} from '@ohos/basicutils';
import { WindowAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/WindowAdapter';
import { WindowConstants, FASlotName, SettingsConstants, HoverConstants, } from '@ohos/commonconstants';
import {
  HiSysEventUtil,
  DeviceHelper,
  EventManager,
  EvtBus,
  PluginSlot,
  WindowEvent,
  HiDfxEventUtil,
  SystemParamUtils,
  ConfigurationEvent,
  TargetPanel,
  GlobalContext,
  DropDownEvent,
} from '@ohos/frameworkwrapper';
import { LightHelper } from '@ohos/systemuicommon/src/main/ets/utils/LightHelper';
import StyleConfiguration, { ToggleBaseComponentStyle, ToggleLabelStyle } from '@ohos/systemuicommon/src/main/ets/template/common/StyleConfiguration';
import DropDownPanelManager from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { FontViewData } from '../vm/LabelViewData';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { LabelViewModel } from '../vm/LabelViewModel';
import { ColorResourceUtils } from '@ohos/systemuicommon/src/main/ets/template/common/ColorResourceUtils';
import { DarkModeEvent, ThemeChangeEvent } from '@ohos/systemuiutils/src/main/ets/sysdialog/CommonEvent';
import { sToggleSubWindowController } from '../../windowmanager/ToggleSubWindowController';
import { AccessibilityUtil } from '@ohos/systemuicommon/src/main/ets/accessibility/AccessibilityUtil';
import { AccessibilityUtilExt } from '../../accessibility/AccessibilityUtilExt';
import { ControlCenterAccessibilityDataModel } from '../../accessibility/AccessibilityDataModel';
import { ControlCenterHideEvent } from '@ohos/systemuicommon/src/main/ets/event/ControlCenterHideEvent';
import { EventHandler, ToggleParam, ToggleStyle, ToggleTemplateType, ToggleScene } from '../interface/ToggleStyle';
import { ToggleBaseViewModel } from '../vm/ToggleBaseViewModel';
import { ToggleViewData } from '../vm/ToggleViewData';
import { DISABLE_BRIGHTNESS } from '@ohos/systemuicommon/src/main/ets/template/common/SCBVisualEffectOption';
import { StorageAdapter } from '../../adapter/StorageAdapter';
import { DropDownAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/DropDownAdapter';

const TAG = 'Ctrl.NewToggleBaseComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const COMPONENT_ID_ICON = TAG + '_Image_';
const COMPONENT_ID_TEXT = TAG + '_Text_';
const COMPONENT_DEFAULT_LOTTIE_NAME = TAG + '_Default';
const TOGGLE_UNAVAILABLE_OPACITY: number = 0.5;
const CLICK_RANGE: number = 80;
const FOLDED_STATE: number = 0;
const DESTROY_LOTTIE_TIMEOUT: number = 20000;
const ICON_TEXT_OPACITY: number = 0.7;

const THRESHOLD_SLIDE: number = 5;
const PC_MAX_FONT_SIZE: number = 15;
const MAX_FONT_SIZE: number = 14;
const MIN_FONT_SIZE: number = 12;
const FONT_LINE_HEIGHT: number = 12;
const ENG_FONT_LINE_HEIGHT: number = 11;
const FONT_PADDING_TOP: number = 7;
const LABEL_TOP_PADDING: number = 3;
const FOCUS_OFFSET: number = 4;
const FONT_SIZE_SCALE: number = 1.2;
const TOGGLE_WIDTH: number = 64;
const LINEAR_GRADIENT_PROPORTION_SUB_LABEL: number = 0.8;
const PC_ICON_LABEL_SPACING: number = 11;

enum ControlCenterState {
  TOGGLE_EDIT = 1,
  SUB_PAGE_STATE = 2,
}

enum LabelType {
  TOGGLE_LABEL_DEFAULT = 0,
  TAGGED_TOGGLE_MAIN_LABEL = 1,
  TAGGED_TOGGLE_SUB_LABEL = 2,
}

@Component
export struct ToggleComponent {
  // 用于区分开关的唯一标识
  toggleId: string = '';
  toggleStyle: ToggleStyle | undefined = undefined;
  templateType: ToggleTemplateType = ToggleTemplateType.BASIC;
  toggleScene: ToggleScene = ToggleScene.PHONE;
  toggleParam: ToggleParam = new ToggleParam();
  eventHandler: EventHandler = new EventHandler();
  toggleViewModel: ToggleBaseViewModel | undefined = undefined;
  decorateFunc: ((style: ToggleStyle) => ToggleStyle) | undefined = undefined;

  private traceTag: string = '';
  private setting: RenderingContextSettings = new RenderingContextSettings(true);
  private context2D: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.setting);
  private isPC: boolean = DeviceHelper.isPC();
  private isLottiePlay: boolean = false;
  private eventMgr: EventManager | undefined = undefined;
  private iconStartY: number = 0;
  private bgStartY: number = 0;
  private lightOnIntensity: number = 2.0;
  private lightOffIntensity: number = 1.2;
  private isHddProduct: boolean = SystemParamUtils.isHddProduct();
  private isEditMode: boolean = false;
  private themeChangeEventMgr: EventManager = EvtBus.createEventManager();
  private symbolEffect: SymbolEffect = new SymbolEffect();
  private isDarkModeState: boolean = false;
  private destroyLottieTimeId: number = -1;
  private isOn: boolean = false;
  private uiContext: UIContext = new UIContext();
  private textHoverFlag: boolean = false;
  private isIconHover: boolean = false;
  private lottieName: string = this.toggleId ?? ''; // 根据名称销毁，因此每次创建的名称应该区分
  private lastLottieName: string = this.toggleId ?? '';
  private lottieItem: AnimationItem | undefined = undefined;
  private isCanvasReady: boolean = false;
  private colorTool: ColorResourceUtils = new ColorResourceUtils(GlobalContext.getContext().resourceManager);
  private colorViewModel: ColorModeViewModel = ColorModeViewModel.getInstance();

  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State @Watch('reLoadAnimation') toggleViewData: ToggleViewData = new ToggleViewData();
  @State style: ToggleBaseComponentStyle = StyleConfiguration.getStyle();
  @State longPressCanceled: boolean = false;
  @State bgScale: number = HoverConstants.HOVER_DEFAULT_SCALE;
  @State iconScale: number = HoverConstants.HOVER_DEFAULT_SCALE;
  @State bloomValue: number = 0;
  @State lightIntensity: number = 0;
  @State lightBrightness: number = 0;
  @State isLottieLoaded: boolean = false;
  @State scaleX: number = 1;
  @State isCanvasRenderGroup: boolean = true;
  @State canvasScale: number = 1;
  @State topRate: number = 0;
  @State topLightUpDegree: number = 0;
  @State newRate: number = 0;
  @State newLightUpDegree: number = 0;
  @State touchDownCount: number = 0;
  @State fontStyle: ToggleLabelStyle = StyleConfiguration.getToggleLabelStyle();
  @State @Watch('onFontViewDataChange') labelViewData: FontViewData = new FontViewData();
  private labelViewModel: LabelViewModel | undefined = undefined;
  @State isLabelHover: boolean = false;
  @State isLabelArrowHover: boolean = false;
  @State isBasicToggleHover: boolean = false;
  @State isHover: boolean = false;
  @State labelHeight: string = '0';
  @State lastLabel: string | Resource | undefined = '';

  @StorageLink('currColorMode')@Watch('onColorModeChange') currColorMode: number =
    GlobalContext.getContext().config.colorMode as number;
  @StorageLink('isLandscape') isLandscape: boolean = false;
  @StorageLink('ControlCenterState') controlCenterState: number = 0;
  @StorageLink('isSysColor') isSysColor: boolean = true;
  @StorageLink('currentDragSlotItem') currentDragSlotItem: string = '';
  @StorageLink('isBusinessStyle') isBusinessStyle: boolean = false;
  @StorageLink('isToggleLightEnabled') isToggleLightEnabled: boolean = true;
  @StorageLink('needReleaseToggleIcon') needReleaseToggleIcon: boolean = false;
  @StorageLink('isMarkingRenderGroupOfControl') isMarkingRenderGroupOfControl: boolean = false;
  @StorageLink('controlCenterFontScale') controlCenterFontScale: number = 1;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;

  @BuilderParam dialogComponent?: CustomBuilder;

  @Styles symbolCommonStyle() {
    .draggable(false)
    .opacity(this.setOpacity(ICON_TEXT_OPACITY, this.toggleViewData.isOn))
    .foregroundBrightness(this.colorModeViewData.getBrightnessOption(
      this.colorModeViewData.getPrimaryFgOption(this.toggleViewData.isOn)))
    .id(COMPONENT_ID_ICON + this.toggleId)
  }

  aboutToAppear() {
    if (this.toggleViewModel == null) {
      log.showError('toggle is unAvailable, create failed');
      return;
    }
    if (this.toggleStyle === undefined) {
      log.showError('toggle style is undefined, create failed');
      return;
    }
    // 将view相关的数据注册到model中，使得model能够驱动view发生变化
    this.toggleViewModel?.initData(this.toggleId);
    if (this.toggleViewModel) {
      this.toggleViewData = this.toggleViewModel?.getViewData();
      this.toggleViewModel.setCustomCommonData(this.toggleScene);
    }
    // 每个开关可以基于基础样式进行装饰
    if (this.toggleStyle) {
      this.toggleStyle = this.toggleViewModel.decorateStyle(this.toggleStyle, this.toggleScene);
    }

    this.labelViewModel = new LabelViewModel(this.labelViewData, this.toggleViewData, this.style, this.isBusinessStyle);
    ControlCenterAccessibilityDataModel.getInstance().set(this.toggleId, this.toggleViewData?.label);
    if (this.eventMgr === undefined) {
      this.eventMgr = EvtBus.createEventManager();
    }
    this.eventMgr.on(WindowEvent, (event: WindowEvent) => {
      if (event.isMatchName(PluginSlot.SLOT_STATUS_CONTROL_CENTER) && event.isWindowEndHide()) {
        this.bgScale = HoverConstants.HOVER_DEFAULT_SCALE;
        if (event) {
          this.updateHoverStatus(event?.isWindowShow())
        }
      }
    });

    this.toggleParam = this.toggleStyle?.toggleParam ?? this.toggleParam;
    this.eventHandler = this.toggleStyle?.eventHandler ?? this.eventHandler;
    this.dialogComponent = this.toggleStyle?.toggleParam?.getDialogComponent();

    // 监听PC控制中心收起，当下拉窗口收起的时候，Canvas图标会概率性出现异常，这个时候用图片代替
    this.eventMgr.on(WindowEvent, (event: WindowEvent) => {
      if (event.isMatchName(PluginSlot.SLOT_STATUS_CONTROL_CENTER) && event.isWindowEndHide()) {
        this.isLottieLoaded = false;
        this.destroyLottie();
      }
    });

    // 控制中心隐藏后20s将Canvas替换成图片，并清理lottie数据
    this.eventMgr.on(WindowEvent, (event: WindowEvent) => {
      // 隐藏下拉窗口
      if (event.windowName === WindowConstants.WINDOW_NAME_DROPDOWN &&
        event.eventType === WindowEvent.EVENT_TYPE_HIDE) {
        this.destroyLottieTimeId = setTimeout(() => {
          this.destroyLottie();
          this.destroyLottieTimeId = -1;
        }, DESTROY_LOTTIE_TIMEOUT);
      }

      // 展开下拉窗口
      if (event.windowName === WindowConstants.WINDOW_NAME_DROPDOWN &&
        event.eventType === WindowEvent.EVENT_TYPE_SHOW) {
        if (this.destroyLottieTimeId !== -1) {
          clearTimeout(this.destroyLottieTimeId);
          this.destroyLottieTimeId = -1;
        }
      }
    });

    log.showInfo(`aboutToAppear, ToggleIcon, slot: ${this.toggleId}, isIconHover: ${this.isIconHover},  isEditMode: ${this.isEditMode}, lottieName: ${this.lottieName}`);
    // 避免首次加载时执行动效
    this.lottieName = this.getLottieName();
    this.lastLottieName = this.lottieName;
    this.themeChangeEventMgr.on(ThemeChangeEvent, this.onProduceThemeUsingEvent);
    this.themeChangeEventMgr.on(DarkModeEvent, (event: DarkModeEvent) => {
      this.isDarkModeState = event.isDarkMode;
      log.showInfo(`newToggleComponent change dark mode: ${this.isDarkModeState}`)
    });
    this.touchDownCount = 0;
    this.isOn = this.toggleViewData?.isOn;
    this.lastLabel = this.toggleViewData.label;

    log.showInfo(`aboutToAppear, ToggleLabel`);
    this.eventMgr.on(ConfigurationEvent, this.labelViewModel?.languageChangeListener);
    if (this.isBusinessStyle) {
      this.eventMgr.on(ConfigurationEvent, this.updateLabelHeight);
      this.updateLabelHeight();
    }
    this.eventMgr.on(ControlCenterHideEvent, (event: ControlCenterHideEvent): void => {
      this.updateLabelStatus(event?.isShowOfWindow)
    })
  }

  private updateLabelHeight = () => {
    this.labelHeight = this.getLabelResponseHeight();
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear, slot: ${this.toggleId} isEdit:${this.isEditMode}`);

    if (this.eventMgr !== undefined) {
      this.eventMgr.offAll();
    }
    this.themeChangeEventMgr.offAll();
  }

  onFontViewDataChange() {
    log.showInfo('fontsize change to: ' + this.labelViewData.fontSize);
  }

  onColorModeChange() {
    if (this.colorViewModel?.getUiContext() === undefined) {
      this.colorViewModel?.setUiContext(this.getUIContext());
    }
    this.colorViewModel.onColorModeChange(this.currColorMode);
    if (!this.isSysColor && !this.isLottiePlay) {
      this.isLottieLoaded = false;
    } else if ((!this.isSysColor || DISABLE_BRIGHTNESS) && this.isLottiePlay) {
      this.changeLottieColor();
    }
  }

  /* 重绘动画：1.深色模式切换；2点击开关；3.从非控制中心的其它地方修改开关状态（比如从设置中修改响铃和静音） */
  reLoadAnimation() {
    log.showInfo('reLoadAnimation');
    if (this.isReadyToPlayLottie()) {
      this.loadLottieAnimate();
    }
    if (this.isBusinessStyle && this.toggleViewData.label !== this.lastLabel) {
      this.labelViewModel?.resetFontAndHoverSize();
    }
  }

  isReadyToPlayLottie(): boolean {
    if (!(this.toggleParam.hasLottieEffect ?? true)) {
      log.showInfo('reLoadAnimation, hasLottieEffect false');
      return false;
    }
    if (!this.isCanvasReady) {
      // 播放动画之前，先确保Canvas 加载完毕
      log.showInfo('reLoadAnimation, isCanvasReady false');
      return false;
    }
    this.lottieName = this.getLottieName();
    if (this.lastLottieName === this.lottieName) {
      log.showInfo(`reLoadAnimation, They're the same`);
      return false;
    }
    // 当下拉窗口不可见的时候，加载动画会概率性出现异常，这个时候用图片代替
    let event: DropDownEvent = DropDownPanelManager.getDropDownEvent();
    if ((!this.isPC && (event.progress < 1 || event.target !== TargetPanel.CONTROL_CENTER_PANEL)) || (this.isPC &&
      !WindowAdapter.isShowingSync(PluginSlot.SLOT_STATUS_CONTROL_CENTER))) {
      log.showInfo(`downPanel is not showing, replace by image: ${this.lottieName}}`);
      this.isLottieLoaded = false;
      this.lastLottieName = this.lottieName;
      return false;
    }
    return true;
  }

  loadLottieAnimate(): void {
    let currentData = this.toggleViewModel?.matchLottieData(true);
    if (currentData === undefined) {
      log.showInfo('reLoadAnimation, currentData undefined');
      // 触发加载新Lottie，保证可以恢复
      this.toggleViewModel?.initLottieData();
      return;
    }
    lottie.destroy(this.lastLottieName);
    this.isLottieLoaded = true;
    this.isCanvasRenderGroup = false;
    log.showInfo(`reLoadAnimation name: ${this.lottieName}`);
    this.lottieItem = lottie.loadAnimation({
      container: this.context2D,
      renderer: 'canvas',
      loop: false,
      autoplay: false,
      name: this.lottieName,
      packageName: 'com.controlCenter',
      frameRate: 60,
      autoSkip: false,
      animationData: currentData
    })
    this.lottieItem.addEventListener('DOMLoaded', (args: Object): void => {
      log.showInfo(`addEventListener DOMLoaded, ${this.lottieItem?.name}`);
      if (this.lottieItem == null) {
        log.showInfo('lottie item is null or undefined');
        return;
      }
      this.changeLottieColor();
      this.startLottieTrace();
      this.isLottiePlay = true;
      this.lottieItem.play();
    })
    this.lastLottieName = this.lottieName;
    this.lottieItem.addEventListener('complete', (args: Object): void => {
      log.showInfo(`addEventListener complete, ${this.lottieItem?.name}`);
      this.isCanvasRenderGroup = true;
      this.isLottiePlay = false;
      this.endLottieTrace();
    })
    this.lottieItem.addEventListener('destroy', (args: Object): void => {
      log.showInfo(`addEventListener destroy, ${this.lottieItem?.name}`);
      if (this.lottieItem?.name == this.lottieName) {
        log.showInfo(`current lottie is detroyed, replaced by image`);
        this.isLottieLoaded = false;
      }
    })
  }

  private changeLottieColor() {
    // 换肤
    if (!this.isSysColor || DISABLE_BRIGHTNESS) {
      if (this.isDarkModeState) {
        let iconOnColorDark = this.colorTool.getArrayColor($r('app.color.Control_center_icon_on_color_dark'));
        let iconDefaultColorDark = this.colorTool.getArrayColor($r('app.color.Control_center_icon_default_color_dark'));
        this.iconChangeColor(iconOnColorDark, iconDefaultColorDark);
      } else {
        let iconOnColor = this.colorTool.getArrayColor($r('app.color.Control_center_icon_on_color'));
        let iconDefaultColor = this.colorTool.getArrayColor($r('app.color.Control_center_icon_default_color'));
        this.iconChangeColor(iconOnColor, iconDefaultColor);
      }
    }
  }

  private startLottieTrace() {
    if (this.traceTag != '') {
      TraceUtil.endTrace(DomainName.CC, this.traceTag, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    }
    AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_START);
    this.traceTag = 'Lottie:' + this.toggleId + ' status:' + this.toggleViewModel?.getState();
    TraceUtil.startTrace(DomainName.CC, this.traceTag, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
  }

  private endLottieTrace() {
    AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_END);
    TraceUtil.endTrace(DomainName.CC, this.traceTag, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    this.traceTag = '';
  }

  private iconChangeColor(onColor: number[], offColor: number[]): void {
    if (this.toggleViewData.isOn) {
      this.lottieItem?.changeColor(onColor);
      this.lottieItem?.changeColor(onColor, onColor);
    } else {
      this.lottieItem?.changeColor(offColor);
      this.lottieItem?.changeColor(offColor, offColor);
    }
  }

  /**
   * 原因：
   * 第一次关闭控制中心，此时 isLabelHover=true，textClickFlag=false；第一次打开控制中心，isLabelHover=true，textClickFlag=true；
   * 第二次关闭控制中心，此时 isLabelHover=true，textClickFlag=true；
   * 第二次打开控制中心（将鼠标移动到桌面其它位置），isLabelHover=true，textClickFlag=true；导致Text组件还是hover态；
   * 思路：
   * 加一个操作，在控制中心关闭时将 isLabelHover 设为false，解决上述问题；
   *
   * 控制中心隐藏时，将 isLabelHover 置为false，防止Text状态不复原
   */
  private updateLabelStatus(isShowOfWindow: boolean) {
    this.isLabelHover = isShowOfWindow;
    this.isLabelArrowHover = isShowOfWindow;
  }


  /**
   * 主题换肤事件生产者
   *
   * @returns 事件
   */
  private onProduceThemeUsingEvent = (event: ThemeChangeEvent):void => {
    if (!this.isLottiePlay) {
      this.isLottieLoaded = false;
    }
  }

  private getLottieName() {
    return this.toggleId + this.toggleViewData.isOn + this.toggleViewModel?.getState();
  }

  private destroyLottie() {
    log.showInfo('destroy lottieName:' + this.lottieName);
    this.isLottieLoaded = false;
    lottie.destroy(this.lottieName);
    this.lottieItem = undefined;
  }

  private getLightIlluminated(): IlluminatedType {
    let isShowPointLight: boolean = LightHelper.getInstance().getIsShowLight() && this.isToggleLightEnabled;
    return isShowPointLight ? IlluminatedType.BORDER_CONTENT : IlluminatedType.NONE;
  }

  private getLongButtonSpaceBetween(): number {
    return this.style.longButtonSpaceBetween;
  }

  private updateHoverStatus(isShowOfWindow: boolean = false) {
    this.isHover = isShowOfWindow;
  }

  @Builder
  ToggleBuilder() {
    if (this.shouldStay()) {
      Stack() {
        Row()
          .backgroundColor(this.getBgColor())
          .backgroundBrightnessInternal(this.templateType === ToggleTemplateType.TAGGED ?
            this.colorModeViewData.getBrightnessOption(this.getTopRate()) :
            this.colorModeViewData.getBrightnessOption(
              this.colorModeViewData.getMainCardOption(this.toggleViewData.isOn)))
          .animation(this.buttonCommonAnim())
          .width('100%')
          .height('100%')
          .borderRadius(this.toggleParam?.getIconBgBorderRadius() ?? (this.getDefaultWidth() as number) / 2)
          .visibility(this.toggleViewData.hideIconBackground ? Visibility.Hidden : Visibility.Visible)
        this.IconBuilder()
        if (this.dialogComponent) {
          this.dialogComponent();
        }
      }
      .width(this.toggleParam?.getIconBgDiameter() ?? this.getDefaultWidth())
      .height(this.toggleParam?.getIconBgDiameter() ?? this.getDefaultWidth())
      .borderRadius(this.toggleParam?.getIconBgBorderRadius() ?? (this.getDefaultWidth() as number) / 2)
      .scale({x: this.iconScale, y: this.iconScale})
      .pointLight(this.getPointLight())
      .borderWidth(this.iconScale < 1.0 ? 1.5 : 0)
      .borderColor(this.handleBoarderColorLogic())
      .onClick(this.onIconClick)
      .responseRegion(this.templateType === ToggleTemplateType.TAGGED && !this.isBusinessStyle ?
        { x: - this.style.longButtonSpaceBetween + 'vp',
          y: - this.style.longButtonSpaceBetween + 'vp',
          width: this.style.topButtonDiameter + this.style.longButtonSpaceBetween + 'vp',
          height: this.style.topButtonDiameter + 2 * this.style.longButtonSpaceBetween + 'vp'} :
        undefined)
      .gesture(LongPressGesture({ repeat: false })
        .onAction(this.onIconItemLongPressGesture)
        .onActionEnd(this.onLongPressEnd))
      .onHover((this.isBusinessStyle && this.templateType === ToggleTemplateType.TAGGED) ?
        undefined : this.onToggleHover)
      .onTouch(this.touchAction)
      // 手机编辑页面屏蔽控制中心主页面的判断
      .focusable(this.toggleParam.getIconFocusable() ?? !this.isEditMode)
      .focusBox({
        margin: new LengthMetrics(2, LengthUnit.VP), //  设置内边距，贴在组件内部绘制
        strokeColor: ColorMetrics.rgba(10, 89, 247), // 设置焦点框线条颜色
        strokeWidth: this.toggleParam?.getIconFocusBoxStrokeWidth() ?? LengthMetrics.vp(2.5) // 设置焦点框线条宽度
      })
      .onKeyPreIme((event: KeyEvent) => {
        return this.isLeftComponent(this.getComponentId()) ?
        this.onKeyPreLeftAction(event) : false
      })
      .geometryTransition(this.getIconTransitionId())
      .accessibilityGroup(this.isAccessibilityMode)
      .accessibilityLevel(this.isEditMode ? 'no' : 'yes')
      .accessibilityText(AccessibilityUtilExt.getToggleText(this.toggleId, this.toggleViewData))
      .accessibilityDescription(AccessibilityUtilExt.getToggleDescription(this.toggleId, this.toggleViewModel))
      .attributeModifier(this.toggleStyle?.attributes)
      .id('transition_toggle' + this.toggleId + (this.isEditMode ? 'edit' : ''))
    }
  }

  private getDefaultWidth(): Length {
    return this.templateType === ToggleTemplateType.BASIC ? this.style.buttonDiameter : this.style.topButtonDiameter;
  }

  private getPointLight(): PointLightStyle {
    if (this.templateType === ToggleTemplateType.TAGGED) {
      return {
        lightSource: {
          positionX: '50%',
          positionY: '50%',
          positionZ: 100,
          intensity: this.lightIntensity * 0.8,
          color: this.getLightColor()
        },
        bloom: this.bloomValue
      };
    } else {
      return {
        lightSource: {
          positionX: '50%',
          positionY: '50%',
          positionZ: 100,
          intensity: this.lightIntensity,
          color: this.getLightColor()
        },
        illuminated: this.handleIlluminatedLogic(),
        bloom: this.bloomValue
      }
    }
  }

  private shouldStay(): boolean {
    if (this.isPC) {
      return true;
    }
    if (this.controlCenterState === ControlCenterState.SUB_PAGE_STATE &&
      this.toggleId === sToggleSubWindowController.getCurrentSubPanelSlot() &&
        this.templateType === ToggleTemplateType.BASIC) {
      return false;
    }
    return true;
  }

  @Builder
  IconBuilder() {
    if (!this.isLottieLoaded && !this.needReleaseToggleIcon) {
      if (this.toggleParam?.getIsSymbolIcon() || this.toggleViewData.isSymbolIcon) {
        this.normalSymbol();
      } else {
        this.imageBuilder()
      }
    }
    this.canvasBuilder()
  }

  @Builder
  normalSymbol() {
    if (this.toggleViewData?.isSymbolActive) {
      SymbolGlyph(this.toggleViewData.icon as Resource)
        .symbolCommonStyle()
        .fontSize(`${this.toggleParam?.getIconDiameter() ?? this.style.iconDiameter}vp`)
        .fontColor(this.getSymbolGlyphFontColor())
        .fontWeight(this.toggleParam?.getSymbolFontWeight() ?? FontWeight.Normal)
        .symbolEffect(this.toggleParam?.getSymbolEffect() ??
          this.symbolEffect, this.toggleViewData?.isSymbolActive ?? false)
        .renderingStrategy(this.toggleParam?.getSymbolRendering() ?? SymbolRenderingStrategy.SINGLE)
    } else {
      SymbolGlyph(this.toggleViewData.icon as Resource)
        .symbolCommonStyle()
        .fontSize(`${this.toggleParam?.getIconDiameter() ?? this.style.iconDiameter}vp`)
        .fontColor(this.getSymbolGlyphFontColor())
        .fontWeight(this.toggleParam?.getSymbolFontWeight() ?? FontWeight.Normal)
        .symbolEffect(this.toggleParam?.getSymbolEffect() ?? this.symbolEffect,
          this.toggleViewData?.symbolTriggerValue ?? -1)
        .renderingStrategy(this.toggleParam?.getSymbolRendering() ?? SymbolRenderingStrategy.SINGLE)
    }
  }

  @Builder
  imageBuilder() {
    Image(this.toggleViewData.icon)
      .edgeAntialiasing(this.style.antialias)
      .draggable(false)
      .size({
        width: this.toggleParam?.getIconDiameter() ?? this.style.iconDiameter,
        height: this.toggleParam?.getIconDiameter() ?? this.style.iconDiameter
      })
      .matchTextDirection(this.toggleParam?.getIsSupportRTL() ? true : false)
      .opacity(this.setOpacity(ICON_TEXT_OPACITY, this.toggleViewData.isOn))
      .padding({ bottom: this.toggleId === 'wifi' ? this.style.wifiButtonBottomPadding : undefined })
      .objectFit(ImageFit.Contain)
      .fillColor(this.toggleViewData.isOn
        ? this.colorModeViewData.commonIconOnColor
        : this.colorModeViewData.commonIconOffColor)
      .foregroundBrightness(this.colorModeViewData.getBrightnessOption(
        this.colorModeViewData.getPrimaryFgOption(this.toggleViewData.isOn)))
      .id(COMPONENT_ID_ICON + this.toggleId)
      .renderGroup(this.isMarkingRenderGroupOfControl && !this.toggleViewData.isUnavailable)
      .onHover((isHover) => {
        if (isHover !== undefined) {
          this.isIconHover = isHover;
        }
      })
  }

  @Builder
  canvasBuilder() {
    if (this.openCanvas()) {
      Canvas(this.context2D)
        .foregroundBrightness(this.colorModeViewData.getBrightnessOption(this.getPrimaryFgOption()))
        .animation(this.buttonCommonAnim())
        .onReady(() => {
          log.showInfo(`lottie, Canvas onReady, lottieName: ${this.lottieName}`);
          this.isCanvasReady = true;
        })
        .onAppear(() => {
          log.showInfo(`lottie, Canvas onAppear, lottieName: ${this.lottieName}`);
          this.isCanvasReady = true;
        })
        .width(this.toggleParam?.getCanvasDiameter() ?? this.getDefaultCanvasWidth())
        .height(this.toggleParam?.getCanvasDiameter() ?? this.getDefaultCanvasWidth())
        .opacity(this.setOpacity(ICON_TEXT_OPACITY, this.toggleViewData.isOn))
        .onDisAppear(() => {
          this.isCanvasReady = false;
          this.isLottieLoaded = false;
          log.showInfo(`lottie, destroy onDisAppear, lottieName: ${this.lottieName}`);
          if (!this.isPC || this.toggleId !== FASlotName.FLASHLIGHT) {
            lottie.destroy(this.lottieName);
            this.lastLottieName = COMPONENT_DEFAULT_LOTTIE_NAME;
          }
        })
        .visibility(this.isLottieLoaded ? Visibility.Visible : Visibility.Hidden)
        .renderGroup(this.isCanvasRenderGroup && !this.toggleViewData.isUnavailable)
        .id(COMPONENT_ID_ICON + this.toggleId);
    }
  }

  private getDefaultCanvasWidth(): Length {
    return this.templateType === ToggleTemplateType.BASIC ? this.style.iconDiameter * 2 : this.style.topButtonDiameter;
  }

  private openCanvas(): boolean {
    return (this.toggleParam?.getHasLottieEffect() ?? true) && !this.needReleaseToggleIcon;
  }

  public getPrimaryFgOption() : BrightnessOptions | undefined {
    return this.colorModeViewData.getPrimaryFgOption(this.toggleViewData.isOn);
  }

  private getIconTransitionId(): string {
    return this.toggleId + (this.toggleParam.getGeometryTransitionId() ?? (this.isEditMode ? 'edit' : ''));
  }

  private getSymbolGlyphFontColor(): ResourceColor[] {
    let fontColor: ResourceColor[] = this.toggleViewData?.isOn ?
      [this.colorModeViewData.commonIconOnColor] : [this.colorModeViewData.commonIconOffColor];
    if (this.toggleParam?.getSymbolRendering() === SymbolRenderingStrategy.MULTIPLE_COLOR) {
      let secondFontColor: ResourceColor = this.toggleViewData?.isOn ? $r('sys.color.icon_on_tertiary') : $r('sys.color.icon_tertiary');
      fontColor.push(secondFontColor);
    }
    return fontColor;
  }

  touchAction = (event: TouchEvent) => {
    if (this.toggleViewData.isUnavailable) {
      // 复位缩放及光照效果
      if (event.type !== TouchType.Down && this.iconScale !== 1) {
        this.lightOff();
      }
      return;
    }
    if (event.type === TouchType.Down) {
      this.longPressCanceled = false;
      this.touchDownCount++;
      this.lightOn();
      this.iconStartY = event.touches[0].y;
    } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      this.lightOff();
    } else if (event.type === TouchType.Move) {
      if (Math.abs(event.touches[0].y - this.iconStartY) > THRESHOLD_SLIDE) {
        this.longPressCanceled = true;
        this.lightOff();
      }
    }
  }

  lightOn() {
    log.showInfo(`light on, slot: ${this.toggleId}`);
    AppStorage.setOrCreate('isToggleLightEnabled', true);
    let isShowPointLight = LightHelper.getInstance().getIsShowLight();
    log.showInfo('isShowPointLight' + isShowPointLight);
    animateTo({
      curve: curves.springMotion(0.31, 0.94)
    }, () => {
      if (!this.isDarkMode()) {
        this.lightIntensity = isShowPointLight ? this.lightOnIntensity : 0;
      } else {
        this.lightIntensity = isShowPointLight ? this.lightOffIntensity : 0;
      }
      if (this.templateType === ToggleTemplateType.BASIC) {
        this.iconScale = 0.9;
      }
    })
    animateTo({
      curve: curves.springCurve(0, 1, 228, 30),
      duration: 222,
      delay: 111
    }, () => {
      this.bloomValue = isShowPointLight ? 1 : 0;
    })
  }

  lightOff() {
    log.showInfo(`light off, slot: ${this.toggleId}`);
    this.bloomValue = 0;
    animateTo({
      curve: curves.springMotion(0.31, 0.94),
      finishCallbackType: FinishCallbackType.LOGICALLY,
      onFinish: () => {
        this.touchDownCount--;
        this.touchDownCount = Math.max(this.touchDownCount, 0);
      }
    }, () => {
      this.lightIntensity = 0;
      if (this.templateType === ToggleTemplateType.BASIC) {
          this.iconScale = 1;
      }
    })
  }

  isDarkMode() {
    return false;
  }

  onKeyPreLeftAction(event: KeyEvent): boolean {
    if (event && event.type === KeyType.Down && event.keyCode === KeyCode.KEYCODE_DPAD_LEFT) {
      return true;
    }
    return false;
  }

  private getComponentId(): string {
    if (this.templateType === ToggleTemplateType.TAGGED) {
      return COMPONENT_ID_ICON + this.toggleId;
    } else {
      return 'transition_toggle' +
      this.toggleId + (this.isEditMode ? 'edit' : '');
    }
  }

  private getBgColor(): ResourceColor {
    if (this.templateType === ToggleTemplateType.TAGGED) {
      return this.toggleViewData?.isOn ?
      this.colorModeViewData.wifiBgOnColor :
      this.colorModeViewData.wifiBgOffColor;
    } else {
      return this.toggleViewData?.isOn
        ? this.colorModeViewData.commonBgOnColor
        : this.colorModeViewData.getSolidColor(
        this.colorModeViewData.commonBgOffColor, this.colorModeViewData.getMainCardOption(this.toggleViewData?.isOn))
    }
  }

  // 当控制中心窗口不可见或者执行深浅模式切换的时候，就不通过本身动画过渡
  private buttonCommonAnim(): AnimateParam | undefined {
    let colorModeChanging: boolean = AppStorage.get('colorModeChanging') as boolean;
    let isWindowVisible: boolean = DropDownAdapter.isDropDownShow() ||
      (this.isPC && WindowAdapter.isShowingSync(PluginSlot.SLOT_STATUS_CONTROL_CENTER));
    let stateChanging: boolean = this.toggleViewData?.isOn !== this.isOn;
    if (stateChanging) {
      this.isOn = this.toggleViewData?.isOn;
    }
    if (isWindowVisible && !colorModeChanging) {
      if (!this.colorModeViewData.isUseSolidColor() || (this.colorModeViewData.isUseSolidColor() && stateChanging)) {
        return { duration: 333, curve: Curve.Smooth };
      }
    }
    return undefined;
  }

  private getTopRate(): BrightnessOptions | undefined {
    return this.colorModeViewData.getTopOption(this.toggleViewData.isOn);
  }

  private getLightColor(): ResourceColor {
    let isPresetTheme: boolean = LightHelper.getInstance().getIsPresetTheme();
    if (isPresetTheme) {
      return $r('app.color.Control_center_preset_theme_light_color');
    }
    return $r('app.color.Control_center_light_color');
  }

  private setOpacity(opacity: number, isOn?: boolean): number {
    if (this.toggleViewData.isUnavailable) {
      return TOGGLE_UNAVAILABLE_OPACITY;
    }
    return this.colorModeViewData.isUseDefaultColor() || isOn || this.isDarkModeState ? 1 : opacity;
  }

  private handleIlluminatedLogic(): IlluminatedType {
    if (!this.isToggleLightEnabled || this.templateType === ToggleTemplateType.TAGGED) {
      return IlluminatedType.NONE;
    }
    let illuminatedType: number = IlluminatedType.NONE;
    let isShowPointLight: boolean = LightHelper.getInstance().getIsShowLight();
    if (!isShowPointLight) {
      illuminatedType = IlluminatedType.NONE;
    }
    if (this.touchDownCount > 0 || this.iconScale < 1.0) {
      if (this.toggleViewData.isOn) {
        illuminatedType = IlluminatedType.NONE;
      } else {
        illuminatedType = IlluminatedType.CONTENT;
      }
    } else {
      illuminatedType = IlluminatedType.BORDER_CONTENT;
    }
    log.showInfo(`handleIlluminated ${illuminatedType}, slot: ${this.toggleId}`);
    return illuminatedType;
  }

  isLeftComponent(id: string) {
    if (this.isLandscape || this.isPC) {
      return false;
    }
    let leftPos: number = this.uiContext.getComponentUtils().getRectangleById(id).windowOffset.x;
    let listPos: number =
      this.uiContext.getComponentUtils().getRectangleById('Ctrl.ControlCenterComponent_MainList').windowOffset.x;
    return leftPos < TOGGLE_WIDTH + listPos;
  }

  private handleBoarderColorLogic() : ResourceColor {
    if (this.iconScale < 1.0 && !this.isHddProduct) {
      if (this.toggleViewData.isOn) {
        return $r('app.color.Control_center_blue_boarder_color');
      }
      return $r('app.color.Control_center_white_boarder_color');
    }
    return Color.Transparent;
  }

  private getLineHeight(): string | number | Resource | undefined {
    if (this.templateType === ToggleTemplateType.TAGGED) {
      return this.style.lineHeight * this.controlCenterFontScale + 'vp'
    } else {
      if (this.labelViewData.isEnglishMode) {
        return this.isBusinessStyle ? ENG_FONT_LINE_HEIGHT * this.controlCenterFontScale + 'vp' : undefined;
      } else if (this.labelViewData.isTibetanMode || this.labelViewData.isUyghurMode) {
        return FONT_LINE_HEIGHT * this.controlCenterFontScale + 'vp';
      } else {
        return this.controlCenterFontScale > FONT_SIZE_SCALE && this.isBusinessStyle ?
          (MAX_FONT_SIZE * this.controlCenterFontScale + 'vp') :
          (this.labelViewData.lineHeight * this.controlCenterFontScale + 'vp');
      }
    }
  }

  @Builder
  loadExpandedToggle() {
    RelativeContainer() {
      Row({ space: this.getLongButtonSpaceBetween() }) {
        this.ToggleBuilder()
        if (this.toggleParam.getHasSubLabel() && this.toggleViewData.isOn) {
          Column() {
            this.labelComponent(LabelType.TAGGED_TOGGLE_MAIN_LABEL);
            this.labelComponent(LabelType.TAGGED_TOGGLE_SUB_LABEL);
          }
          .height(this.toggleParam?.getLabelHeight())
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
        } else if (this.toggleParam.getHasLabel()) {
          this.labelComponent(LabelType.TOGGLE_LABEL_DEFAULT);
        }
      }
      .padding({ start: LengthMetrics.vp(this.style.longButtonLeftMargin),
        end: LengthMetrics.vp(this.style.longButtonRightMargin) })
      .borderRadius($r('app.float.Control_center_long_button_radius'))
      .height('100%')
      .width('100%')
      .onHover((isHover?: boolean) => {
        if (isHover !== undefined) {
          this.isHover = isHover;
        }
      })
      .attributeModifier(this.toggleStyle?.attributes)

      if (this.isBusinessStyle && this.isHover) {
        SymbolGlyph($r('sys.symbol.small_triangle_arrow_down_right_fill'))
          .draggable(false)
          .fontSize(this.style.bussinessStyleTopToggleSymbolSize + 'vp')
          .fontColor(this.currColorMode ?
            [Color.Black] : [Color.White])
          .position({
            bottom: LengthMetrics.vp(this.style.bussinessStyleToggleSymbolMarginBottom),
            end: LengthMetrics.vp(this.style.bussinessStyleToggleSymbolMarginBottom)
          })
          .opacity(0.4)
          .id(COMPONENT_ID_ICON + this.toggleId)
          .zIndex(-1);
      }

      if (!this.isBusinessStyle && this.isHover) {
        Image($r('app.media.icon_arrow'))
          .fillColor(this.colorModeViewData.wifiOffTextColor)
          .foregroundBrightness(this.colorModeViewData.getBrightnessOption(
            this.colorModeViewData.foregroundPrimaryOptionOnBackground))
          .draggable(false)
          .width($r('app.float.Control_center_hover_arrow_size'))
          .height($r('app.float.Control_center_hover_arrow_size'))
          .alignRules(this.getAlignRules())
      }
    }
    .backgroundColor(this.colorModeViewData.getSolidColor(
      this.colorModeViewData.commonBgOffColor, this.colorModeViewData.mainCardOption))
    .backgroundBrightnessInternal(
      this.colorModeViewData.getBrightnessOption(this.colorModeViewData.mainCardOption))
    .height('100%')
    .width('100%')
    .borderRadius($r('app.float.Control_center_long_button_radius'))
    .scale({ x: this.bgScale, y: this.bgScale })
    .onTouch(this.onTopToggleTouch)
    .onHover(this.onToggleHover)
  }

  getAlignRules(): AlignRuleOption {
    return {
      'right': { 'anchor': '__container__', 'align': HorizontalAlign.End },
      'center': { 'anchor': '__container__', 'align': VerticalAlign.Center }
    }
  }

  private isTaggedToggleSubLabelOverflow(): boolean {
    let labelWidth: number = px2vp(MeasureText.measureText({
      textContent: this.getText(LabelType.TAGGED_TOGGLE_SUB_LABEL),
      fontSize: this.getFontSize(LabelType.TAGGED_TOGGLE_SUB_LABEL),
      fontFamily: 'HarmonyHeiTi',
      fontWeight: this.toggleParam?.getFontWeight() ?? this.labelViewData.fontWeight,
    }));
    return labelWidth >
      (this.toggleParam?.getLabelWidth() ?? this.style.buttonLabelWidth * this.controlCenterFontScale);
  }

  private getLabelResponseHeight(): string {
    let labelSize: SizeOptions = this.getUIContext().getMeasureUtils().measureTextSize({
      textContent: this.getText(),
      constraintWidth: this.style.buttonLabelWidth,
      fontSize: this.getFontSize(),
      textAlign: this.toggleParam?.getLabelAlign() ?? TextAlign.Center,
      maxLines: 2,
      fontFamily: 'HarmonyHeiTi',
      fontWeight: this.toggleParam?.getFontWeight() ?? this.labelViewData.fontWeight,
      lineHeight: this.toggleParam?.getFontLineHeight() ?? this.getLineHeight(),
      overflow: TextOverflow.Ellipsis,
      wordBreak: this.toggleParam?.getLabelWordBreak() ?? WordBreak.BREAK_WORD
    })
    let labelHeight: number = this.getUIContext()?.px2vp(labelSize.height as number) ?? 0;
    let topPadding: number = this.labelViewData.isTibetanMode ? FONT_PADDING_TOP :
      (this.labelViewData.isUyghurMode ? LABEL_TOP_PADDING : this.style.buttonLabelPadding)
    return (labelHeight + this.style.buttonLabelSpace + topPadding) * HoverConstants.HOVER_QUICK_BTN_SCALE + 'vp';
  }

  @Builder
  labelComponent(labelType?: LabelType) {
    Text(this.getText(labelType))
      .responseRegion({
        x: 0,
        y: (this.isBusinessStyle && this.templateType === ToggleTemplateType.BASIC) ?
          (- (this.labelViewData.isChineseMode ? PC_ICON_LABEL_SPACING : this.style.buttonLabelSpace) + 'vp') : 0,
        width: '100%',
        height:  (this.isBusinessStyle && this.templateType === ToggleTemplateType.BASIC) ? this.labelHeight : '100%'
      })
      .textAlign(this.toggleParam?.getLabelAlign() ?? TextAlign.Center)
      .draggable(false)
      .fontFamily($r('app.string.Control_center_long_button_font_family'))
      .fontColor(this.getFontColor())
      .foregroundBrightness(this.getForeGroundBrightness(labelType))
      .fontWeight(this.toggleParam?.getFontWeight() ?? this.labelViewData.fontWeight)
      .fontSize(this.getFontSize(labelType))
      .maxFontSize(this.isBusinessStyle ? undefined :
        this.templateType === ToggleTemplateType.TAGGED && labelType === LabelType.TOGGLE_LABEL_DEFAULT ?
        MAX_FONT_SIZE * this.controlCenterFontScale + 'vp' : undefined)
      .minFontSize(this.isBusinessStyle ? undefined :
        this.templateType === ToggleTemplateType.TAGGED && labelType === LabelType.TOGGLE_LABEL_DEFAULT ?
        MIN_FONT_SIZE * this.controlCenterFontScale + 'vp' : undefined)
      .lineHeight(this.toggleParam?.getFontLineHeight() ?? this.getLineHeight())
      .maxLines(labelType === LabelType.TAGGED_TOGGLE_SUB_LABEL ? (this.toggleParam?.getSubLabelMaxLines() ?? 1) : 2)
      .width(this.toggleParam?.getLabelWidth() ??
        (this.isBusinessStyle ? undefined : this.style.buttonLabelWidth * this.controlCenterFontScale))
      .height(this.toggleParam.getHasSubLabel() ? undefined : this.toggleParam?.getLabelHeight())
      .padding({
        top: this.templateType === ToggleTemplateType.BASIC ?
          (this.labelViewData.isTibetanMode ? FONT_PADDING_TOP :
          (this.labelViewData.isUyghurMode ? LABEL_TOP_PADDING :
            (this.isBusinessStyle && this.labelViewData.isChineseMode ? 0 : this.style.buttonLabelPadding))) : 0
      })
      .constraintSize(this.toggleParam?.getLabelConstraintSize())
      .textOverflow({ overflow: labelType === LabelType.TAGGED_TOGGLE_SUB_LABEL ?
        TextOverflow.MARQUEE : TextOverflow.Ellipsis })
      .marqueeOptions({ start: false, fadeout: true })
      .wordBreak(this.toggleParam?.getLabelWordBreak() ?? WordBreak.BREAK_WORD)
      .id(COMPONENT_ID_TEXT + this.toggleId)
      .opacity(labelType === LabelType.TAGGED_TOGGLE_SUB_LABEL ?
        this.toggleParam?.getSubLabelOpacity() : this.setOpacity(ICON_TEXT_OPACITY))
      .focusable(this.toggleParam?.getLabelFocusable())
      .renderGroup(this.templateType === ToggleTemplateType.TAGGED ?
        undefined :
        (this.isMarkingRenderGroupOfControl && !this.toggleViewData.isUnavailable))
      .visibility(this.currentDragSlotItem === this.toggleId && this.templateType !== ToggleTemplateType.TAGGED ?
        Visibility.Hidden : Visibility.Visible)
      .onMouse((event) => {
        // 解决快捷键拉起控制中心，出现鼠标在Text上，isLabelHover依旧为false的问题（先执行onMouse，再执行onAreaChange）
        if (event.action === MouseAction.Hover) {
          // 鼠标不动的情况下，快捷键唤起控制中心面板，此时 Text 组件状态是 hover 态；
          // 将 textHoverFlag 标志设为true，防止onAreaChange 将 isLabelHover 复位
          this.textHoverFlag = true;
        } else {
          this.textHoverFlag = false;
        }
      })
      .gesture(LongPressGesture({ repeat: false })
        .onAction(this.onIconItemLongPressGesture)
        .onActionEnd(this.onLongPressEnd))
      .onClick(this.onLabelClick)
      .onHover((isHover) => {
        if (isHover !== undefined) {
          if (this.isBusinessStyle && this.templateType === ToggleTemplateType.BASIC) {
            this.isBasicToggleHover = isHover
            this.onToggleHover(isHover);
          }
          this.isLabelHover = isHover;
        }
      })
      .accessibilityGroup(this.isAccessibilityMode)
      .accessibilityText(AccessibilityUtilExt.getToggleLabelText(this.toggleId, this.toggleViewData))
      .accessibilityLevel(this.getLabelAccessibilityLevel(labelType))
  }

  @Builder
  subLabelComponent() {
    // 文本超长时渐隐处理
    Row() {
      Row() {
        this.labelComponent(LabelType.TAGGED_TOGGLE_SUB_LABEL);
      }
      .blendMode(BlendMode.SRC_IN, BlendApplyType.OFFSCREEN)
    }
    .linearGradient(this.isTaggedToggleSubLabelOverflow() ? {
      direction: this.labelViewData.isRTL ? GradientDirection.Left : GradientDirection.Right,
      colors: [
        [this.getFontColor(), 0],
        [this.getFontColor(), LINEAR_GRADIENT_PROPORTION_SUB_LABEL],
        [Color.Transparent, 1]
      ]
    } : {
      colors: [[this.getFontColor(), 1]]
    })
    .blendMode(BlendMode.SRC_OVER, BlendApplyType.OFFSCREEN)
  }

  private getTextTopPadding(): number {
    return this.labelViewData.isTibetanMode ? this.style.fontPaddingTop :
      (this.labelViewData.isUyghurMode ? this.style.labelTopPadding : this.style.buttonLabelPadding);
  }

  private getText(labelType?: LabelType): string | Resource | undefined {
    if (labelType === LabelType.TAGGED_TOGGLE_SUB_LABEL) {
      return this.toggleViewData.subLabel;
    }
    return this.toggleViewData.label;
  }

  private getForeGroundBrightness(labelType?: LabelType): BrightnessOptions | undefined {
    if (this.templateType === ToggleTemplateType.BASIC) {
     if (this.isPC) {
       return this.colorModeViewData.foregroundPrimaryOption;
     } else {
       return this.colorModeViewData.isBrightnessActive ?
       this.colorModeViewData.getBrightnessOption(this.fontStyle.labelStyle) : undefined;
     }
    } else if (this.templateType === ToggleTemplateType.TAGGED) {
      if (labelType === LabelType.TAGGED_TOGGLE_SUB_LABEL) {
        return undefined;
      }
      return this.colorModeViewData.getBrightnessOption(
        this.colorModeViewData.foregroundPrimaryOptionOnBackground)
    } return undefined;
  }

  private getFontSize(labelType?: LabelType): string | number | Resource | undefined {
    if (this.templateType === ToggleTemplateType.BASIC) {
      let fontSize: number = this.labelViewData.fontSize * this.controlCenterFontScale;
      // pc底部开关文本字体大小超过15就会换行，当前策略将字体最大尺寸限制为15
      if (this.isBusinessStyle && fontSize >= PC_MAX_FONT_SIZE) {
        fontSize = PC_MAX_FONT_SIZE;
      }
      return fontSize + 'vp';
    } else if (this.templateType === ToggleTemplateType.TAGGED) {
      if (this.isBusinessStyle) {
        if (this.labelViewData.isEnglishMode || this.labelViewData.isTibetanMode || this.labelViewData.isUyghurMode) {
          return this.style.topOtherButtonFontSize * this.controlCenterFontScale + 'vp';
        }
        return this.style.topPcButtonFontSize * this.controlCenterFontScale + 'vp';
      } else {
        if (labelType === LabelType.TAGGED_TOGGLE_MAIN_LABEL) {
          return this.style.topButtonMainFontSize * this.controlCenterFontScale + 'vp';
        } else if (labelType === LabelType.TAGGED_TOGGLE_SUB_LABEL) {
          return this.style.topButtonSubFontSize * this.controlCenterFontScale + 'vp';
        }
        return this.style.topButtonFontSize * this.controlCenterFontScale + 'vp';
      }
    } else return undefined;
  }

  private getFontColor(): ResourceColor {
    if (this.templateType === ToggleTemplateType.TAGGED) {
      return this.toggleViewData.isOn
        ? this.colorModeViewData.wifiOnTextColor
        : this.colorModeViewData.wifiOffTextColor;
    } else {
      return this.fontStyle.labelColor;
    }
  }

  onTopToggleTouch = (event: TouchEvent) => {
    if (this.toggleViewData.isUnavailable) {
      return;
    }
    if (event.type === TouchType.Down) {
      this.bgStartY = event.touches[0].y;
      animateTo({
        curve: curves.springMotion(0.31, 0.94)
      }, () => {
        this.bgScale = 0.9;
      })
    } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      this.TopToggleTouchOff();
    } else if (event.type === TouchType.Move) {
      if (Math.abs(event.touches[0].y - this.bgStartY) > THRESHOLD_SLIDE) {
        this.TopToggleTouchOff();
      }
    }
  }

  TopToggleTouchOff() {
    animateTo({
      curve: curves.springMotion(0.31, 0.94)
    }, () => {
      this.bgScale =
        this.isIconHover ? HoverConstants.HOVER_QUICK_BTN_SCALE : HoverConstants.HOVER_DEFAULT_SCALE;
    })
  }

  @Builder
  loadBasicToggle() {
      Column({ space: this.isBusinessStyle && this.labelViewData.isChineseMode ?
          PC_ICON_LABEL_SPACING : this.style.buttonLabelSpace }) {
        this.ToggleBuilder()
        if (this.toggleParam.getHasLabel() === true) {
          Stack() {
            this.labelComponent()
            if (this.toggleParam.getLabelArrow()) {
              this.PCLabelArrow()
            }
          }
        }
      }
      .padding(this.toggleParam?.getIconLabelPadding())
      .width(this.toggleParam?.getBgWidth() ?? this.style.buttonDiameter + this.style.newIconPadding * 2)
      .height(this.toggleParam?.getBgHeight() ?? this.style.buttonDiameter + this.style.buttonLabelSpace +
        this.style.buttonLabelHeight + this.style.newIconPadding)
      .scale({ x: this.bgScale, y: this.bgScale })
      .onHover((isHover?: boolean) => {
        if (isHover !== undefined) {
          this.isHover = isHover;
        }
      })
      .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
  }

  @Builder
  PCLabelArrow() {
    SymbolGlyph($r('sys.symbol.small_triangle_arrow_down_right_fill'))
      .draggable(false)
      .fontSize(this.style.bussinessStyleSymbolSize + 'vp')
      .fontColor(this.currColorMode ?
        [Color.Black] : [Color.White])
      .opacity(this.isBasicToggleHover ? 0.4 : 0)
      .id(COMPONENT_ID_ICON + this.toggleId)
      .position({
        end: LengthMetrics.vp(-10),
        bottom: LengthMetrics.vp(this.style.bussinessStyleSymbolMarginBottom),
      })
      .width(11)
      .height(11)
      .padding({
        start: LengthMetrics.vp(2)
      })
      .focusable(false)
      .onClick(this.onLabelClick)
      .onHover((isHover) => {
        if (isHover !== undefined) {
          this.isLabelArrowHover = isHover;
          this.isBasicToggleHover = isHover;
          this.onToggleHover(isHover);
        }
      })
      .onMouse((event) => {
        // 解决快捷键拉起控制中心，出现鼠标在Text上，isLabelHover依旧为false的问题（先执行onMouse，再执行onAreaChange）
        if (event.action === MouseAction.Hover) {
          // 鼠标不动的情况下，快捷键唤起控制中心面板，此时 Text 组件状态是 hover 态；
          // 将 textHoverFlag 标志设为true，防止onAreaChange 将 isLabelHover 复位
          this.textHoverFlag = true;
        } else {
          this.textHoverFlag = false;
        }
      })
  }

  @Builder
  loadDraggingToggle() {
    Stack() {
      Image(this.toggleViewData.icon)
        .size({ width: this.style.iconDiameter, height: this.style.iconDiameter })
        .fillColor(this.toggleViewData.isOn ? this.style.newIconOnColor : this.style.newIconOffColor)
    }.size({ width: this.style.buttonDiameter, height: this.style.buttonDiameter })
    .borderRadius(this.style.buttonDiameter)
    .backgroundColor(this.toggleViewData.isOn ? '#ccffffff' : '#99000000')
  }

  build() {
    if (this.templateType === ToggleTemplateType.TAGGED) {
      this.loadExpandedToggle()
    } else {
      this.loadBasicToggle()
    }
  }

  /**
   * 开关悬浮事件
   *
   * @param isHover 是否显示hover效果
   */
  onToggleHover = (isHover?: boolean) => {
    if (isHover === undefined || this.toggleViewData.isUnavailable) {
      return;
    }
    this.isIconHover = this.isHover;
    this.isBasicToggleHover = isHover;
    animateTo({
      duration: HoverConstants.HOVER_ANIMATE_DURATION,
      curve: Curve.Sharp
    }, () => {
      this.bgScale = isHover ? HoverConstants.HOVER_QUICK_BTN_SCALE : HoverConstants.HOVER_DEFAULT_SCALE;
    });
  }

  /**
   * 开关点击事件
   *
   * @param event 事件
   */
  onIconClick = (event?: ClickEvent) => {
    log.showInfo('onIconClick: ' + this.toggleId);
    if (this.eventHandler?.getOnIconClick()) {
      // 无障碍处理
      AccessibilityUtil.sendControlCenterToggleClickAccessibility(
        AccessibilityUtilExt.getToggleIconClickText(this.toggleId, this.toggleViewModel));
    }
    if (this.eventHandler?.getOnIconClick() && this.toggleViewModel) {
      this.eventHandler.getOnIconClick()?.(this.toggleViewModel, event);
      // 上报开关点击事件
      this.reportClick();
    }
  }

  onLabelClick = (event: ClickEvent) => {
    log.showInfo('onLabelClick');
      if (this.eventHandler?.getOnLabelClick() && this.toggleViewModel && !this.toggleViewData.isUnavailable) {
        this.eventHandler?.getOnLabelClick()?.(this.toggleViewModel, event, this.toggleId);
        this.reportClick();
      }
  }

  /**
   * 开关长按事件
   *
   * @param event 事件
   */
  onIconItemLongPressGesture = (event?: GestureEvent) => {
    log.showDebug(`onIconItemLongPressGesture, event: ${event?.repeat}--${event?.offsetX}--${event?.offsetY}--${event?.angle}--${event?.speed}
      ${event?.scale}--${event?.pinchCenterX}--${event?.pinchCenterY}--${event?.velocityX}--${event?.velocityY}--${event?.velocity}`);
    if (this.eventHandler?.getOnIconLongPressOnAction() && this.toggleViewModel && !this.toggleViewData.isUnavailable) {
      this.eventHandler?.getOnIconLongPressOnAction()?.(this.toggleViewModel, event, this.toggleId);
      // 上报开关长按事件
      this.reportLongClick();
    }
  }

  onLongPressEnd = (event?: GestureEvent) => {
    if (this.longPressCanceled) {
      log.showDebug('long press canceled');
      return;
    }
    if (this.eventHandler?.getOnIconLongPressOnActionEnd() &&
      this.toggleViewModel && !this.toggleViewData.isUnavailable) {
      log.showInfo('_onIconLongPressOnActionEnd');
      this.eventHandler?.getOnIconLongPressOnActionEnd()?.(this.toggleViewModel, event);
      HiSysEventUtil.reportCCQuickToggleLongClick({
        LOCKSTATUS: AppStorage.get('lockStatus'),
        TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
        BUTTON_NAME: this.toggleId ?? '',
        STATE: `${this.toggleViewData.isOn}`,
        TYPE: 1,
        SCREENTYPE: 0
      });
    } else if (this.eventHandler?.getOnIconLongPressOnActionEnd() &&
      this.toggleViewModel && !this.toggleViewData.isUnavailable &&
      !this.toggleViewModel.customCommonData.isSupportLongClickAction) {
      // 长按回弹后如果不支持二级界面或者长按跳转的情况下，按照单击处理
        this.eventHandler?.getOnIconLongPressOnActionEnd()?.(this.toggleViewModel, event);
        HiSysEventUtil.reportCCQuickToggleLongClick({
          LOCKSTATUS: AppStorage.get('lockStatus'),
          TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
          BUTTON_NAME: this.toggleId ?? '',
          STATE: `${this.toggleViewData.isOn}`,
          TYPE: 1,
          SCREENTYPE: 0
        });
    }
  }

  private reportLongClick() {
    HiDfxEventUtil.reportToggleClick(this.toggleId ?? '', HiDfxEventUtil.TOGGLE_TYPE_LONG_CLICK);
    if (this.toggleViewModel && (this.toggleViewModel?.openDetailPageFunc || this.toggleViewModel?.startServiceFunc)) {
      if (this.toggleId === FASlotName.WIFI_UI_EXTENSION || this.toggleId === FASlotName.BLUETOOTH_UI_EXTENSION) {
        HiSysEventUtil.reportCCQuickToggleLongClick({
          LOCKSTATUS: AppStorage.get('lockStatus'),
          TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
          BUTTON_NAME: this.toggleId ?? '',
          STATE: `${this.toggleViewData.isOn}`,
          TYPE: 1,
          SCREENTYPE: 0
        });
      } else if (this.toggleId === FASlotName.RING_MODE) {
        HiSysEventUtil.reportCCQuickToggleLongClickSound({
          LOCKSTATUS: AppStorage.get('lockStatus'),
          TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
          NEWSTATE: this.toggleViewModel.getState(),
        });
      } else if (this.toggleId === FASlotName.EBOOK) {
        HiSysEventUtil.reportCCQuickToggleLongClickEBook({
          LOCKSTATUS: AppStorage.get('lockStatus'),
          TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
          NEWSTATE: this.toggleViewData.isOn ? this.toggleViewModel.getState() :
          Number(SettingsConstants.EBOOK_MODE_ENABLE_DEFAULT),
        });
      } else {
        HiSysEventUtil.reportCCQuickToggleLongClick({
          LOCKSTATUS: AppStorage.get('lockStatus'),
          TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
          BUTTON_NAME: this.toggleId ?? '',
          STATE: `${this.toggleViewData.isOn}`,
          TYPE: 1,
          SCREENTYPE: 0
        });
      }
    }
  }

  private reportClick() {
    HiDfxEventUtil.reportToggleClick(this.toggleId ?? '', HiDfxEventUtil.TOGGLE_TYPE_CLICK);
    if (this.toggleId !== FASlotName.RING_MODE && this.toggleId !== FASlotName.EBOOK) {
      HiSysEventUtil.reportCCQuickToggleClick({
        LOCKSTATUS: AppStorage.get('lockStatus'),
        TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
        BUTTONNAME: this.toggleId ?? '',
        // 深色模式由于需要根据回调刷新状态，导致isOn状态延迟，打点时需要提前取反
        STATE: `${this.toggleId !== FASlotName.DARK_MODE ? this.toggleViewData.isOn : !this.toggleViewData.isOn}`,
        TYPE: 1,
        SCREENTYPE: 0
      });
    }
  }

  /**
   * 获取开关Label的无障碍焦点可见性
   *
   * @returns no 不获焦 auto 默认焦点
   */
  private getLabelAccessibilityLevel(labelType?: LabelType): string {
    if (!this.isAccessibilityMode) {
      return 'auto';
    }
    if (this.templateType === ToggleTemplateType.BASIC) {
      return 'no';
    }
    if (!this.toggleViewData.isOn &&
      (this.toggleId === FASlotName.WIFI_UI_EXTENSION || this.toggleId === FASlotName.BLUETOOTH_UI_EXTENSION)) {
      return 'no';
    }
    if ((this.toggleViewData.isUnavailable || labelType !== LabelType.TAGGED_TOGGLE_SUB_LABEL) &&
      (this.toggleId === FASlotName.HOTSPOT_TAGGED || this.toggleId === FASlotName.MOBILE_DATA_TAGGED)) {
      return 'no';
    }
    return 'auto';
  }
}