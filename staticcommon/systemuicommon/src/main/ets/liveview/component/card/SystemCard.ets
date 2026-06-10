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
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { EventManager, EvtBus } from '@ohos/frameworkwrapper';
import { CardUtils } from './LiveViewCardData';
import { LiveSystemTemplate } from '../../data/template/LiveSystemTemplate';
import { LiveViewData } from '../../data/LiveViewData';
import { LiveTimeComponent } from './SystemComponent/LiveTimeComponent';
import { LiveProgressComponent } from './SystemComponent/LiveProgressComponent';
import {
  LiveUseScene,
  LiveViewCommonConstants,
  SysTypeCode,
  LiveButtonState,
  WDefault,
  LiveExtendType
} from '../../common/LiveConstants';
import { immersiveKgMgr } from '../../../immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import { ObservedItem } from '../../../model/ObservedModel';
import { fontScaleManager } from '@ohos/systemuiutils/src/main/ets/fontScale/fontScaleManager';
import { FontScaleState } from '@ohos/systemuiutils/src/main/ets/fontScale/fontScaleState';
import { LiveViewExtendStyle } from '../../data/extend/LiveViewExtendStyle';
import { LiveButtonData } from '../../data/extend/LiveButtonData';
import { DarkModeState } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseState';
import { LiveButtonComponent, onLiveButtonClick } from './SystemComponent/LiveButtonComponent';
import { ColorModeViewModel } from '../../../template/newStyle/ColorModeViewModel';
import { ColorModeViewData } from '../../../template/newStyle/ColorModeViewData';
import { NotificationType } from '../../../constants/NotificationType';
import { LiveTimeParams } from './framenode/LiveTimeParams';
import { LiveTimeController } from './framenode/LiveTimeController';
import { AccessibilityAppName } from '../../../accessibility/AccessibilityAppName';
import { AccessibilityLevel } from '../../../accessibility/AccessibilityData';
import { TextEmojiHelper } from '../../../utils/TextEmojiHelper';
import { IconResource } from '../../data/IconResource';
import { LengthMetrics } from '@ohos.arkui.node';
import { DarkModeSwitchDoneEvent } from '../../../event/DarkModeSwitchDoneEvent';
import { LiveAccessibilityUtil } from '../../common/liveAccessibilityUtil';
import { image } from '@kit.ImageKit';
import { LiveCustomerStyle } from '../../info/card/LiveCustomerStyle';
import { OverlayIconStyle } from '../../../model/NotificationContent';
import { OuterHomeVm } from '../../../../ets/vm/OuterHomeVm'
import { ColorModeLiveViewData } from '../../../template/newStyle/ColorModeLiveViewData';
import { ResUtils } from '@ohos/windowscene';
import { LiveStyle } from '../../../live/constants/LiveStyle';
import { SystemUICcmConfig } from '../../../utils/SystemUICcmConfig';

const TAG = LiveViewCommonConstants.LOG_PREFIX + 'SystemCard';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const CARD_LARGE_ICON_CIRCLE_RADIUS: Resource = $r('app.float.live_view_card_large_icon_width');
const CARD_LARGE_ICON_SQUARE_RADIUS: string = '8vp';

// 禁止在无障碍模式下聚焦应用图标的应用bundle列表，已知有计时器、录音机
const DISABLE_ICON_CLICK_LIST: string[] = ['com.ohos.clock', 'com.ohos.soundrecorder'];

@Component
export struct SystemCard {
  @ObjectLink @Watch('baseDataUpdate') baseData: LiveViewData;
  @State buttonData?: LiveButtonData[] = [];
  @ObjectLink data: LiveSystemTemplate;
  isImmersiveLive: boolean = false;
  customerStyle?: LiveCustomerStyle;
  @Prop isSmallFoldOuterScreen: boolean = false;

  /**
   * sim卡图标的大小
   */
  @State simIconSize: number | undefined = 0;
  @StorageLink('Notification_DarkModeModel_DarkModeStatus') darkMode: DarkModeState = new DarkModeState();

  /**
   * 是否开启辅助功能朗读模式
   */
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;

  /**
   * 通知面板类型
   */
  @Consume notificationType: number;

  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State colorModeLiveViewData: ColorModeLiveViewData = ColorModeViewModel.getInstance().getLiveViewData();

  /**
   * 长辈模式字体
   */
  @State fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();

  useScene: LiveUseScene = LiveUseScene.SCENE_LIVE_LIST;

  private extendStyle = new LiveViewExtendStyle();

  /**
   * 事件统一管理
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  /**
   * 预加载时间组件控制器
   */
  @State liveTimeController: LiveTimeController | null = null;

  @Prop isNeedBannerInScreenLock: boolean = false;
  @Prop isShowBannerFromScreenLock: boolean = false;
  @State outerHomeVm: OuterHomeVm = OuterHomeVm.get();
  /**
   * 应用名称
   */
  @State appName?: ObservedItem<string> = undefined;

  /**
   * 图片更新函数key
   */
  private iconUpdaterKey: string = '';

  async aboutToAppear() {
    log.showInfo(`aboutToAppear, ${this.useScene} system type=${this.baseData?.sysTypeCode}`);
    // 初始化LiveTimeController
    await this.initLiveTimeController();
    if (this.baseData?.getButtonData()?.length) {
      this.iconUpdaterKey = this.baseData?.hashCode + '#' + this.useScene;
      log.showInfo(`addUpdater ${this.iconUpdaterKey}`);
      this.buttonData = this.baseData?.getButtonData()?.slice(0) ?? [];
      IconResource.buttonDataUpdaters.set(this.iconUpdaterKey, this.buttonDataUpdater);
    }
    this.appName = this.baseData?.appName;
  }

  baseDataUpdate() {
    this.buttonDataUpdater();
  }

  private async initLiveTimeController() {
    if (this.useScene === LiveUseScene.SCENE_LIVE_LIST ||
      this.useScene === LiveUseScene.SCENE_NTF_CENTER ||
      this.useScene === LiveUseScene.SCENE_HEADS_UP) {
      const params = new LiveTimeParams();
      params.timeData = this.baseData?.getTimerData();
      params.viewFontSize = $r('sys.float.ohos_id_text_size_headline6');
      params.viewFontColor =  $r('sys.color.ohos_id_color_text_primary');
      params.marginBottom = 0;
      params.isBigTextTimer = true;
      const liveTimeControllerObj = new LiveTimeController(this.getUIContext(), params);
      this.liveTimeController = await liveTimeControllerObj.getController();
      // NodeContainer主动更新深浅色资源, 如果ArkUi的深浅色上下文还没设置好，会导致获取资源对象异常进而导致深浅色切换异常
      this.eventMgr.on(DarkModeSwitchDoneEvent, this.onDarkModeEvent);
    }
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear ${this.useScene}, delete buttonUpdater: ${this.iconUpdaterKey}`);
    IconResource.buttonDataUpdaters.delete(this.iconUpdaterKey);
    if (this.useScene === LiveUseScene.SCENE_LIVE_LIST || this.useScene === LiveUseScene.SCENE_NTF_CENTER ||
      this.useScene === LiveUseScene.SCENE_HEADS_UP) {
      this.eventMgr.offAll();
      this.liveTimeController = null;
    }
  }

  /**
   * 刷新按钮图标数据
   */
  buttonDataUpdater = () => {
    if (this.checkIconResource()) {
      log.showInfo(`update Button Data`);
      this.buttonData = this.baseData?.getButtonData()?.slice(0);
    }
  }

  /**
   * 深浅色切换更新NodeContainer资源
   */
  onDarkModeEvent = () => {
    this.liveTimeController?.updateConfiguration();
  }

  checkIconResource(): boolean {
    return this.baseData?.getButtonData()?.[0]?.iconResource != undefined;
  }

  build() {
    Column() {
      Row({ space: 12 }) {
        if (!this.isImmersiveLive) {
          this.constructImage()
        }
        this.constructFixedArea()
        if (!this.shouldHideContent()) {
          this.constructAuxiliaryArea()
        }
      }
      .width('100%')
      .height(LiveViewCommonConstants
        .getCardHeight(66, this.fontScaleState.getFontScale(this.outerHomeVm.isIgnoreFontScaleState),
          LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA))
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .padding(this.isSmallFoldOuterScreen ? undefined : {
        left: CardUtils.LIVE_VIEW_CARD_PADDING,
        right: CardUtils.LIVE_VIEW_CARD_PADDING,
      })
    }
    .justifyContent(FlexAlign.Center)
    .borderRadius(CardUtils.ITEM_BG_RADIUS)
    .clip(true)
    .id(LiveViewCommonConstants.getItemContentId(this.baseData?.hashCode, this.useScene))
    .margin({
      bottom: this.customerStyle?.cardMarginBottom ?? undefined,
      left: this.customerStyle?.cardMarginHorizontal ?? undefined,
      right: this.customerStyle?.cardMarginHorizontal ?? undefined
    })
  }

  @Builder
  constructImage() {
    Stack() {
      // 左侧大图
      Image(this.getLeftIcon())
        .width($r('app.float.live_view_card_large_icon_width'))
        .height($r('app.float.live_view_card_large_icon_height'))
        .objectFit(ImageFit.Contain)
        .draggable(false)
        // 图标叠加场景使用圆形图标
        .clip(this.shouldHideContent() ? false : this.data?.hasOverlayIcon())
        .interpolation(ImageInterpolation.Medium)
        .border((!this.data?.hasOverlayIcon() || this.shouldHideContent() ||
          this.data?.getOverlayIconStyle() === OverlayIconStyle.REVERSE) ? {
          radius: CARD_LARGE_ICON_SQUARE_RADIUS
        } : {
          width: '1px',
          color: '#3F808080',
          radius: this.data?.getOverlayIconStyle() === OverlayIconStyle.SQUARE ? CARD_LARGE_ICON_SQUARE_RADIUS :
            CARD_LARGE_ICON_CIRCLE_RADIUS
        })
        .autoResize(false)
        .accessibilityLevel(this.getAccessibilityLevel())
        .opacity(WDefault.MAX_VALUE)
        .onClick(this.baseData?.getIconClickListener(this.useScene, this.isNeedBannerInScreenLock,
          this.isShowBannerFromScreenLock))

      if (this.data?.getOverlayIconStyle() !== OverlayIconStyle.REVERSE) {
        // 叠加场景，左侧小图
        if ((this.data?.hasOverlayIcon() && !this.shouldHideContent())) {
          Column()
            .width(LiveViewCommonConstants.LIVE_SMALL_ICON_SIZE)
            .height(LiveViewCommonConstants.LIVE_SMALL_ICON_SIZE)
            .borderRadius(LiveViewCommonConstants.LIVE_SMALL_ICON_BORDER_RADIUS)
            .offset({ x: $r('app.float.live_view_card_icon_offset'), y: $r('app.float.live_view_card_icon_offset') })
            .visibility(this.getSmallColumnVisibility())
            .accessibilityLevel(AccessibilityLevel.NO)
          Image(this.data?.getLeftSmallIcon())
            .width(LiveViewCommonConstants.LIVE_SMALL_ICON_SIZE)
            .height(LiveViewCommonConstants.LIVE_SMALL_ICON_SIZE)
            .offset({ x: $r('app.float.live_view_card_icon_offset'), y: $r('app.float.live_view_card_icon_offset') })
            .borderRadius(LiveViewCommonConstants.LIVE_SMALL_ICON_BORDER_RADIUS)
            .objectFit(ImageFit.Contain)
            .draggable(false)
            .interpolation(ImageInterpolation.Medium)
            .accessibilityLevel(AccessibilityLevel.NO)
            .opacity(WDefault.MAX_VALUE)
        }
      }
    }
    .margin({
      end: this.data?.overlayIcon ? LengthMetrics.resource($r('app.float.live_view_card_overlay_icon_start_end')) :
      LengthMetrics.vp(0),
    })
    .width(this.data?.overlayIcon ? $r('app.float.live_view_card_overlay_large_icon_size') :
    $r('app.float.live_view_card_large_icon_width'))
    .height(this.data?.overlayIcon ? $r('app.float.live_view_card_overlay_large_icon_size') :
    $r('app.float.live_view_card_large_icon_height'))
    .offset({
      start: this.data?.overlayIcon ? LengthMetrics.resource($r('app.float.live_view_card_overlay_icon_offset')) :
      LengthMetrics.vp(0),
    })
    .renderGroup(!!this.data?.overlayIcon)
  }

  @Builder
  constructorTitle() {
    // 标题计时器
    if (this.isTimerInTitle() && !this.shouldHideContent()) {
      if (this.baseData?.appIndex > 0) {
        this.buildLiveTimeComponentCloneLabel()
      } else {
        LiveTimeComponent({
          timeData: this.baseData?.getTimerData(),
          viewFontSize: $r('sys.float.ohos_id_text_size_sub_title3'),
          viewFontColor: this.getTitleFontColor(),
        })
      }
    } else {
      if (this.baseData?.appIndex > 0) {
        this.buildCardTextCloneLabel()
      } else {
        this.buildCardTitle()
      }
    }
  }

  @Builder
  buildLiveTimeComponentCloneLabel() {
    Row() {
      LiveTimeComponent({
        timeData: this.baseData?.getTimerData(),
        viewFontSize: $r('sys.float.ohos_id_text_size_sub_title3'),
        viewFontColor: this.getTitleFontColor(),
      })

    }
  }

  @Builder
  buildCardTitle() {
    Text(this.getTitleText())
      .fontFamily('HarmonyHeiTi')
      .fontWeight(FontWeight.Medium)
      .fontSize(this.fontScaleState.getScaleSize($r('sys.float.ohos_id_text_size_sub_title3'),
        this.outerHomeVm.isIgnoreFontScaleState))
      .fontFeature('\"ss08\" on')
      .fontColor($r('sys.color.ohos_id_color_text_primary'))
      .wordBreak(WordBreak.BREAK_ALL)
      .textAlign(TextAlign.Start)
      .maxLines(1)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .margin({
        bottom: $r('app.float.live_view_card_title_margin_bottom'),
      })
      .lineHeight(this.fontScaleState.getScaleSize($r('app.float.live_view_card_text_line_height'),
        this.outerHomeVm.isIgnoreFontScaleState))
      .renderGroup(true)
  }

  @Builder
  buildCardTextCloneLabel() {
    Row() {
      this.buildCardTitle()
    }
  }

  @Builder
  constructAuxiliaryArea() {
    if (this.data?.getExtendData(LiveExtendType.TYPE_COMMON_PROGRESS)) {
      LiveProgressComponent({
        baseData: this.baseData,
        progressData: this.baseData.getProgressData(),
        extendStyle: this.extendStyle
      })
        .opacity(undefined)
    }

    if (this.baseData?.getButtonData()?.length) {
      if (this.isAccessibilityMode){
        Stack() {
          Row({ space: 12 }) {
            this.constructAuxiliaryAreaButtons()
          }

          Row({ space: 12 }) {
            ForEach(this.checkIconResource() ? this.buttonData : this.baseData?.getButtonData(),
              (buttonData: LiveButtonData, index: number) => {
                Column() {}
                .accessibilityText(this.getAccessibilityText(index))
                .accessibilityRole(AccessibilityRoleType.BUTTON)
                .width(this.extendStyle.buttonHeight)
                .height(this.extendStyle.buttonHeight)
                .onClick(() => this.onAccessibilityModeClick(index))
              }, (buttonData: LiveButtonData, index: number) => buttonData.hashCode + '#' + index);
          }
        }.accessibilityText(' ')
      } else {
        this.constructAuxiliaryAreaButtons()
      }
    }
  }

  @Builder
  constructAuxiliaryAreaButtons() {
    ForEach(this.checkIconResource() ? this.buttonData : this.baseData?.getButtonData(),
      (buttonData: LiveButtonData) => {
        LiveButtonComponent({
          baseData: this.baseData,
          buttonData: buttonData,
          extendStyle: this.extendStyle,
          isDarkMode: this.darkMode.isDarkMode,
          bgBrightnessOption: this.getBrightnessOption(buttonData),
          isBrightnessDisable: this.colorModeViewData.isNtfBrightnessDisable,
          liveBtnNoBrightnessBgColor: this.colorModeViewData.calcSecondarySolidColor(
            this.getLiveButtonNoBrightnessBgColor(buttonData), this.getBrightnessOption(buttonData),
            this.colorModeLiveViewData.liveBgPickColor)
        })
      });
  }

  @Builder
  constructFixedArea() {
    Column() {
      AccessibilityAppName({
        name: LiveAccessibilityUtil.getAccessibilityAppName(this.baseData),
        isAccessibilityMode: this.isAccessibilityMode
      })

      // 渲染时如果controller是undefined，NodeContainer会不渲染也无法watch，故增加liveTimeStages判断
      if (this.baseData?.sysTypeCode === SysTypeCode.BIG_TEXT_TIMER &&
        !this.shouldHideContent()) {
        if (this.liveTimeController) {
          NodeContainer(this.liveTimeController)
        } else {
          LiveTimeComponent({
            timeData: this.baseData?.getTimerData(),
            viewFontSize: $r('sys.float.ohos_id_text_size_headline6'),
            viewFontColor: $r('sys.color.ohos_id_color_text_primary'),
            marginBottom: 0,
            isBigTextTimer: true,
          })
        }
      } else {
        this.constructorTitle()
        this.constructContent()
      }
    }
    .padding(this.isSmallFoldOuterScreen ? undefined : {
      top: $r('app.float.live_view_card_padding_top_bottom'),
      bottom: $r('app.float.live_view_card_padding_top_bottom')
    })
    .layoutWeight(1)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  constructContent() {
    Flex() {
      // SIM卡图标 , 隐藏内容时不显示
      if (this.data?.hasSimIcon() && !this.shouldHideContent()) {
        this.buildSimIcon()
      }

      // 内容计时器
      if (this.isTimerInContent() && !this.shouldHideContent()) {
        LiveTimeComponent({
          timeData: this.baseData?.getTimerData(),
          viewFontSize: $r('sys.float.ohos_id_text_size_body2'),
          viewFontColor: $r('sys.color.ohos_id_color_text_secondary'),
          marginBottom: 0,
          foreBrightnessOption: this.colorModeViewData.foregroundSecondaryOption
        })
          .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
            this.setSimIconSize(newValue?.height as number);
          })
      } else {
        Text(this.getSubtext())
          .textAlign(TextAlign.Start)
          .fontFamily('HarmonyHeiTi')
          .fontWeight(FontWeight.Regular)
          .fontSize(this.fontScaleState.getScaleSize($r('sys.float.ohos_id_text_size_body2'),
            this.outerHomeVm.isIgnoreFontScaleState))
          .fontFeature('\"ss08\" on')
          .fontColor(this.getContentFontColor())
          .foregroundBrightness(this.colorModeViewData.isSolidEnable() ? undefined : this.colorModeViewData.systemLiveFontOption)
          .wordBreak(WordBreak.BREAK_ALL)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .draggable(false)
          .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
            this.setSimIconSize(newValue?.height as number);
          })
          .renderGroup((this.hasEmoji()) ? false : true)
          .lineHeight(this.fontScaleState.getScaleSize($r('app.float.live_view_card_text_line_height'),
            this.outerHomeVm.isIgnoreFontScaleState))
      }
    }
    .width('100%')
  }

  @Builder
  buildSimIcon() {
    Image(this.data?.getSimIcon())
      // 图标大小与文本高度保持一致
      .width(this.simIconSize)
      .height(this.simIconSize)
      .objectFit(ImageFit.Contain)
      .draggable(false)
        // 图标颜色与文本颜色保持一致
      .fillColor($r('sys.color.ohos_id_color_text_secondary'))
      .padding({
        top: LengthMetrics.vp(LiveViewCommonConstants.LIVE_SIM_PADDING_TOP),
        bottom: LengthMetrics.vp(LiveViewCommonConstants.LIVE_SIM_PADDING_BOTTOM),
        end: LengthMetrics.vp(LiveViewCommonConstants.LIVE_SIM_PADDING_RIGHT)
      })
      .interpolation(ImageInterpolation.Medium)
      .flexShrink(0)
  }

  private getSmallColumnVisibility() {
    if (this.useScene === LiveUseScene.SCENE_SCREEN_LOCK) {
      return Visibility.Hidden;
    }
    return Visibility.None;
  }

  private hasEmoji(): boolean {
    let textEmojiHelper: TextEmojiHelper = new TextEmojiHelper();
    if (this.data?.content) {
      return textEmojiHelper.isEmoji(this.data?.content);
    }
    return false;
  }

  /**
   * 获取含计时控件的系统通知AOD下显示的文本内容
   *
   * @returns string AOD下显示的文本内容
   */
  private getAodTimeText(): string | undefined {
    return this.isTimerInTitle() ? this.getSubtext() : this.getTitleText();
  }

  /**
   * 标题上是否存在计时器
   *
   * @returns true 标题计时器
   */
  private isTimerInTitle(): boolean {
    let timer = this.baseData?.getTimerData();
    if (CommonUtils.isInvalid(timer)) {
      return false;
    }
    return timer?.isInTitle ?? false;
  }

  /**
   * 内容上是否存在计时器
   *
   * @returns true 内容计时器
   */
  private isTimerInContent(): boolean {
    let timer = this.baseData?.getTimerData();
    if (CommonUtils.isInvalid(timer)) {
      return false;
    }
    return !(timer?.isInTitle ?? false);
  }

  /**
   * 通知是否存在计时器
   *
   * @returns true 存在计时器
   */
  private isTimer(): boolean {
    return !CommonUtils.isInvalid(this.baseData?.getTimerData());
  }

  /**
   * 设置sim图标大小
   */
  private setSimIconSize(height: number | undefined) {
    // 在下一个周期执行，规避图标被判定为位置变化受到动效影响
    setTimeout(() => {
      // SIM卡图标与文本高度保持一致
      this.simIconSize = height;
    });
  }

  /**
   * 设置button提亮色
   */
  private getBrightnessOption(buttonData: LiveButtonData): BrightnessOptions {
    if (buttonData) {
      if (buttonData.buttonState === LiveButtonState.ON) {
        return this.colorModeViewData.systemLiveButtonOnBgCardOption;
      }
      if (buttonData.buttonState === LiveButtonState.OFF) {
        return this.colorModeViewData.systemLiveButtonOffBgCardOption;
      }
    }
    return this.colorModeViewData.systemLiveButtonOffBgCardOption;
  }

  private getLiveButtonNoBrightnessBgColor(buttonData: LiveButtonData): ResourceColor {
    let systemLiveBtnBgColor: ResourceColor = '#FF000000';
    if (!this.colorModeViewData.isNtfBrightnessDisable) {
      return systemLiveBtnBgColor;
    }
    if (buttonData) {
      if (buttonData.buttonState === LiveButtonState.ON) {
        return $r('app.color.live_btn_on_disable_brightness_bg_color');
      }
      if (buttonData.buttonState === LiveButtonState.OFF) {
        return $r('app.color.live_btn_off_disable_brightness_bg_color');
      }
    }
    return $r('app.color.live_btn_off_disable_brightness_bg_color');
  }

  private getTitleText(): string {
    if (this.shouldHideContent()) {
      return this.appName?.value ?? '';
    }
    return `${this.data?.title ?? ''}`;
  }

  private getSubtext(): string {
    if (this.shouldHideContent()) {
      return this.baseData?.contentHideText ?? '';
    }
    return `${this.data?.content ?? ''}`;
  }

  private shouldHideContent(): boolean {
    return this.baseData?.shouldHideContent(this.useScene, this.isNeedBannerInScreenLock,
      this.isShowBannerFromScreenLock);
  }

  private getLeftIcon(): image.PixelMap | string | DrawableDescriptor {
    if (this.data?.getOverlayIconStyle() === OverlayIconStyle.REVERSE) {
      return this.data?.getAppIcon();
    }
    if (this.shouldHideContent()) {
      return this.data?.getSmallIcon() ?? this.data?.getAppIcon();
    }
    return this.data?.getLeftLargeIcon();
  }

  private getAccessibilityLevel(): string {
    if (this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD &&
      DISABLE_ICON_CLICK_LIST.includes(this.baseData.creatorBundleName)) {
      return AccessibilityLevel.NO;
    }
    return AccessibilityLevel.AUTO;
  }

  private getAccessibilityText(index: number) {
    const forEachList = this.checkIconResource() ? this.buttonData : this.baseData?.getButtonData();
    if (forEachList && !CommonUtils.isInvalid(forEachList?.[index])) {
      let buttonData = forEachList[index];
      return buttonData.accessibilityText;
    }
    return '';
  }

  private onAccessibilityModeClick(index: number) {
    const forEachList = this.checkIconResource() ? this.buttonData : this.baseData?.getButtonData();
    if (forEachList && !CommonUtils.isInvalid(forEachList?.[index])) {
      let buttonData = forEachList[index];
      onLiveButtonClick(buttonData, this.baseData);
    }
  }

  private isOuterScreenImmersiveLive2(): boolean {
    return SystemUICcmConfig.instance.isEnabledLive2 && this.isSmallFoldOuterScreen && this.isImmersiveLive;
  }

  private getTitleFontColor(): number | Resource | string | undefined {
    if (this.isOuterScreenImmersiveLive2()) {
      return LiveStyle.LIVE_CARD_TITLE_FONT_COLOR;
    }
    return 'sys.color.ohos_id_color_text_primary';
  }

  private getContentFontColor(): number | Resource | string | Color | undefined {
    if (this.isOuterScreenImmersiveLive2()) {
      return LiveStyle.LIVE_CARD_TEXT_FONT_COLOR;
    }

    return this.colorModeViewData.calcSecondarySolidColor($r('sys.color.ohos_id_color_text_secondary'),
      this.colorModeViewData.systemLiveFontOption, this.colorModeLiveViewData.liveBgPickColor)
  }
}