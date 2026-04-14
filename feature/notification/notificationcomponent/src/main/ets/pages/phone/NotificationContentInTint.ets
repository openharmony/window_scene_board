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

import { NotificationEntry } from '../../model/NotificationEntry';
import { NotificationConfig } from '../../common/NotificationConfig';
import curves from '@ohos.curves';
import {
  BannerDeformState,
  bannerMgr,
  DarkModeState,
  fontScaleManager,
  FontScaleState,
  NtfMultiLineContent,
  ObservedItem,
  OverlayIconStyle
} from '@ohos/systemuicommon';
import { NotificationActionView } from '../common/NotificationActionView';
import { CommonData } from '@ohos/controlcentercommon/Index';
import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import {
  AccessibilityAppName,
  ColorModeViewData,
  ColorModeViewModel
} from '@ohos/systemuicommon/Index';
import { notificationStyle } from '../../vm/style/NotificationStyle';
import measure from '@ohos.measure';
import { NtfColorModeVM } from '../../vm/NtfColorModeVM';
import { NtfTimeVM } from '../../vm/NtfTimeVM';
import NtfMgr from '@ohos.notificationManager';
import { AppProtectedVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedVm';
import { LengthMetrics } from '@kit.ArkUI';
import { NotificationUtils, ChildFunctionWrapper } from '../../common/NotificationUtils';
import { NtfSingleItemVM } from '../../vm/NtfSingleItemVM';
import { ColorModeNCViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeNCViewData';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';

const SUB_TITLE_OPACITY: number = 1;
const CONTENT_OPACITY: number = 1;
const TIME_TITLE_OPACITY: number = 1;
const CONTENT_TRANSLATE_Y: number = 22;
const ARROW_REVOLVE_ANGLE: number = 180;
const TRANSLATE_ANIM: ICurve = curves.cubicBezierCurve(0.2, 0, 0.2, 1);
const OPACITY_ANIM: ICurve = curves.cubicBezierCurve(0.2, 0, 0.83, 1);
const OPACITY_DURATION: number = 118;
const TRANSLATE_DURATION: number = 333;
const BANNER_WIDTH = 328;

const TAG = 'NotificationContentInTint';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

@Component
export struct NotificationContentInTint {

  /**
   * 下拉标签
   */
  @BuilderParam arrowDownChild: () => void = this.arrowDownBuilder;

  @Builder
  arrowDownBuilder() {
    Circle()
      .width($r('app.float.ntf_button_size_in_tint'))
      .height($r('app.float.ntf_button_size_in_tint'))
      .fill(this.colorModeViewData.calcSecondarySolidColor(this.fontColor,
        this.colorModeVM?.circleButtonBgBrightnessOptions, this.colorModeNCViewData.bannerBgPickColor))
      .foregroundBrightness(this.colorModeViewData.isSolidEnable() ? undefined :
        this.colorModeVM?.circleButtonBgBrightnessOptions)

    Image($r('app.media.ic_public_arrow_down'))
      .objectFit(ImageFit.Fill)
      .width($r('app.float.tint_ntf_arrow_width'))
      .height($r('app.float.tint_ntf_arrow_height'))
      .fillColor(this.fontColor)
  }

  /**
   * 深浅模式Pc
   */
  @StorageLink('DarkModeModel_DarkModeStatus') @Watch('onDarkModeChanged') darkModeDataPc: CommonData =
    new CommonData();

  /**
   * 深浅模式
   */
  @StorageLink('Notification_DarkModeModel_DarkModeStatus')
  @Watch('onDarkModeChanged') darkModeData: DarkModeState = new DarkModeState();
  /**
   * 是否开启辅助功能朗读模式
   */
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  /**
   * 长辈模式字体
   */
  @State fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();

  @Consume ntfEntry: NotificationEntry;

  /**
   * 通知面板类型
   */
  @Consume notificationType: number;

  /**
   * TimeView使用，使用固定白色
   */
  @Provide contentColor: string = '';

  /**
   * 执行位移动画
   */
  @State isMove: boolean = false;

  /**
   * 横幅通知展开状态
   */
  @Link isExpand: boolean;

  /**
   * 图标尺寸
   */
  @State iconSize: Resource = $r('app.float.ntf_small_icon_size_in_tint');

  /**
   * 副标题位移数据
   */
  @State subtitleTranslateY: number = 0;

  /**
   * 副标题位移数据
   */
  @State subtitleTranslateX: number = 0;

  /**
   * 副标题透明度
   */
  @State subtitleOpacity: number = SUB_TITLE_OPACITY;

  /**
   * 时间区块位移
   */
  @State timeTranslateY: number = 0;

  /**
   * 时间区块透明度
   */
  @State timeOpacity: number = 0;

  @State fontColor: Resource = (DeviceHelper.isPC() ? this.darkModeDataPc.status : this.darkModeData.isDarkMode) ?
  $r('app.color.tint_ntf_title_font_color_dark_mode') : $r('app.color.tint_ntf_title_font_color_light_mode');

  /**
   * 形变相关参数
   */
  @Prop bannerDeformState: BannerDeformState | undefined = undefined;
  /**
   * 应用图标尺寸
   */
  @State appIconSize: Resource = $r('app.float.ntf_small_icon_size_in_tint');
  /**
   * 图标圆角
   */
  private appIconBorderRadius: Resource = $r('app.float.ntf_action_button_radius');
  /**
   * 图标偏移量
   */
  @State appIconOffset: Length = 0;

  @State appName?: ObservedItem<string> = undefined;

  @State colorModeVM: NtfColorModeVM | undefined = undefined;
  private colorModeNCViewData: ColorModeNCViewData = ColorModeViewModel.getInstance().getNCViewData();

  /**
   * 时间戳VM
   */
  @State timeVm: NtfTimeVM = new NtfTimeVM();

  private colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();

  @Prop isNeedBannerInScreenLock: boolean = false;
  @Prop isShowBannerFromScreenLock: boolean = false;
  @Prop isLockScreen: boolean = false;
  @State @Watch('onProtectedStatusChange') protectedVm: AppProtectedVm = AppProtectedVm.get();
  @Prop isInitParam: boolean = false;
  persistentId: number = 0;
  /**
   * 横幅通知宽度
   */
  @Prop @Watch('itemWidthChange') itemWidth: number = 0;
  /**
   * 标题宽度
   */
  @State titleWidth: number | undefined = undefined;
  /**
   * 通知内容是否超过一行
   */
  @State isContentOverMaxLine: boolean = true;

  checkWrapper: ChildFunctionWrapper = new ChildFunctionWrapper();

  private onProtectedStatusChange(): void {
    if (this.protectedVm.isProtected(this.ntfEntry.bundleIdxTag) && this.isExpand) {
      this.foldAnimate();
    }
  }

  /**
   * 下拉DropBar是否可见
   */
  private isDropBarVisible: boolean = false;
  private transitionEffect: TransitionEffect = TransitionEffect.asymmetric(
    TransitionEffect.OPACITY.animation({
      duration: OPACITY_DURATION,
      delay: 90,
      curve: OPACITY_ANIM
    })
      .combine(TransitionEffect.translate({
        x: 10,
        y: -22
      }).animation({duration: TRANSLATE_DURATION, curve: TRANSLATE_ANIM})),
    TransitionEffect.IDENTITY
  );

  private ntfItemVM?: NtfSingleItemVM;

  aboutToAppear(): void {
    if (this.ntfEntry.overlayIcon) {
      this.appIconSize = $r('app.float.ntf_small_iconn_with_overlay_icon_size_in_tint');
      this.appIconBorderRadius = $r('app.float.ntf_action_button_with_overlay_icon_radius');
      this.appIconOffset = $r('app.float.ntf_small_icon_in_tint_offset_phone');
    }
    this.checkWrapper.checkBool = (): boolean => { return this.checkHasArrow(); };
    this.appName = this.ntfEntry.appName;
    this.isContentOverMaxLine = this.checkOverMaxLine();
    this.timeVm.init(this.ntfEntry.deliveryTime, this.ntfEntry.hashCode);
    this.titleWidth = this.getTitleLength();
  }

  aboutToDisappear(): void {
    this.timeVm.deinit();
  }

  private itemWidthChange(): void {
    log.showInfo(`item width changed ${this.itemWidth}`);
    this.titleWidth = this.getTitleLength();
  }

  onDarkModeChanged(): void {
    this.fontColor = (DeviceHelper.isPC() ? this.darkModeDataPc.status : this.darkModeData.isDarkMode) ?
    $r('app.color.tint_ntf_title_font_color_dark_mode') :
    $r('app.color.tint_ntf_title_font_color_light_mode');
  }

  // 隐藏横幅通知条件函数
  private isHiddenBannerContent(): boolean {
    if (bannerMgr.isHiddenBannerContent(this.ntfEntry?.isHideContent, this.isNeedBannerInScreenLock,
      this.isShowBannerFromScreenLock)) {
      return true;
    }
    return false;
  }

  build() {
    if (!this.protectedVm.isProtected(this.ntfEntry.bundleIdxTag) &&
      !ArrayUtils.isEmpty(this.ntfEntry?.actionButtons)) {
      Column() {
        this.buildNtfContent(true);
        if (this.shouldShowActionButtons()) {
          NotificationActionView({
            persistentId: this.persistentId,
            colorModeVM: this.colorModeVM,
            isDropBarVisible: this.isDropBarVisible,
            isNeedPanelInScreenLock: this.isNeedBannerInScreenLock,
            isLockScreen: this.isLockScreen,
            ntfItemVM: this.ntfItemVM,
            isHeadsUp: true
          })
        }
      }
      .width('100%')
    } else {
      this.buildNtfContent();
    }
  }

  @Builder
  buildHideBannerNtfTitle() {
    Text(this.appName?.value)
      .draggable(false)
      .id(TAG + '_AppName')
      .fontSize(this.fontScaleState.getScaleSize($r('app.float.ntf_title_font_size')))
      .fontColor($r('app.color.theme_ntf_color_text_primary'))
      .fontWeight(FontWeight.Medium)
      .maxLines(NotificationConfig.LAYOUT_WEIGHT_ONE)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .renderGroup(true)
      .flexShrink(0)
  }

  @Builder
  buildNtfContent(isWithActionButtons: boolean = false) {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
      if ((this.protectedVm.isProtected(this.ntfEntry.bundleIdxTag) || this.isHiddenBannerContent()) &&
        this.ntfEntry.overlayIconStyle !== OverlayIconStyle.REVERSE) {
        this.buildAppIcon();
      } else {
        this.buildAppIconPortrait();
      }

      Column() {
        AccessibilityAppName({
          name: this.appName?.value,
          isAccessibilityMode: this.isAccessibilityMode,
        })
      }
      Stack({ alignContent: this.isMove ? Alignment.TopEnd : Alignment.End }) {
        this.buildNtfSummaryContent();
        this.buildNtfExpandContent();
      }
      .padding({
        start: LengthMetrics.resource($r('app.float.ntf_item_padding_start_end')),
        top: this.isMove ? '2vp' : undefined,
        bottom: this.isMove ? '2vp' : undefined
      })
      .flexGrow(1)
    }
    .gesture(GestureGroup(GestureMode.Parallel,
      TapGesture().onAction((event: GestureEvent) => {
        log.showInfo(`onTapGesture`);
        if (!this.isExpand) {
          this.expendAnimate();
        }
      }),
      PanGesture({ direction: PanDirection.Down, distance: ArkUIAdapter.px2vp(1) })
        .onActionEnd((event) => {
          log.showInfo(`vertical down swipe end`);
          if (!this.isExpand) {
            this.expendAnimate();
          }
        })
        .onActionCancel(() => {
          log.showInfo(`vertical down swipe canceled`);
          if (!this.isExpand) {
            this.expendAnimate();
          }
        })
    ))
    .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
      log.showInfo(`onGestureJudgeBegin, gesture type:${gestureInfo.type}`);
      if (DeviceHelper.isPC()) {
        return GestureJudgeResult.REJECT;
      }
      // 点击手势判定
      if (gestureInfo.type === GestureControl.GestureType.TAP_GESTURE && this.shouldReject()) {
        return GestureJudgeResult.REJECT;
      }
      // 拖动手势判定
      if (gestureInfo.type === GestureControl.GestureType.PAN_GESTURE) {
        let panEvent = event as PanGestureEvent;
        // 向下竖滑
        if (panEvent.offsetY > 0 && this.shouldReject()) {
          log.showInfo(`vertical down swipe, reject`);
          return GestureJudgeResult.REJECT;
        }
      }
      return GestureJudgeResult.CONTINUE;
    })
    .height(this.isInitParam && this.bannerDeformState ?
      this.bannerDeformState.bannerHeight - this.getActionBtnHeight(isWithActionButtons) : undefined)
    .width('100%')
    .clickEffect({ level: ClickEffectLevel.LIGHT })
    .padding({
      left: $r('app.float.ntf_item_padding_start_end'),
      right: $r('app.float.ntf_item_padding_start_end'),
      top: this.isExpand ? $r('app.float.ntf_heads_up_drop_margin_bottom') :
        $r('app.float.tint_ntf_item_padding_start_end'),
      bottom: this.isExpand ? $r('app.float.ntf_heads_up_drop_margin_bottom') :
        $r('app.float.tint_ntf_item_padding_start_end')
    })
  }

  /**
   * 应用锁保护态/智能提醒隐藏/已展开/通知内容没有超长 子组件不处理手势
   * 子组件在判定中返回Reject, 表示子组件不处理此次手势, 冒泡给父组件处理
   * @returns
   */
  private shouldReject(): boolean {
    return this.protectedVm.isProtected(this.ntfEntry.bundleIdxTag) || this.isHiddenBannerContent() || this.isExpand ||
      !this.isContentOverMaxLine;
  }

  @Builder
  buildNtfSummaryContent() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: ItemAlign.Center,
      justifyContent: this.isExpand ? FlexAlign.SpaceBetween : FlexAlign.Start
    }) {
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Baseline, justifyContent: FlexAlign.Start }) {
        if (this.isHiddenBannerContent() || this.protectedVm.isProtected(this.ntfEntry.bundleIdxTag)) {
          this.buildHideBannerNtfTitle();
        } else {
          Text(this.ntfEntry?.notificationContent?.contentTitle)
            .draggable(false)
            .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontWeight(FontWeight.Medium)
            .fontSize(this.fontScaleState.getScaleSize($r('app.float.ntf_title_font_size')))
            .fontColor(this.colorModeVM?.ntfThemeTextPrimaryColor)
            .wordBreak(WordBreak.BREAK_ALL)
            .lineHeight(this.fontScaleState.getScaleSize($r('app.float.ntf_text_line_height')))
            .flexShrink(0)
            .textAlign(RTLUtil.isRTL() ? TextAlign.End : TextAlign.Start)
            .width(this.titleWidth)
        }

        Text(this.getNtfContent())
          .draggable(false)
          .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontWeight(FontWeight.Regular)
          .fontSize(this.fontScaleState.getScaleSize($r('app.float.ntf_title_font_size')))
          .fontColor(this.colorModeVM?.ntfThemeTextPrimaryColor)
          .foregroundBrightness(this.colorModeVM?.themeFontForegroundOptions)
          .lineHeight(this.fontScaleState.getScaleSize($r('app.float.ntf_text_line_height')))
          .wordBreak(WordBreak.BREAK_ALL)
          .opacity(this.subtitleOpacity)
          .translate({ y: this.subtitleTranslateY, x: this.subtitleTranslateX })
          .flexShrink(1)
          .flexGrow(1)
          .textAlign(RTLUtil.isRTL() ? TextAlign.End : TextAlign.Start)
          .padding({ start: LengthMetrics.resource($r('app.float.tint_ntf_title_padding_end')) })
      }
      .flexShrink(1)
      .flexGrow(1)

      // 通知时间
      if (this.isContentOverMaxLine) {
        this.buildTimestamp();
      }
    }.width('100%')
    .margin({ top: this.isExpand ? $r('app.float.ntf_heads_up_drop_margin_bottom') : 0 })
  }

  private getNtfContent(): ResourceStr {
    if (this.protectedVm.isProtected(this.ntfEntry.bundleIdxTag) || this.isHiddenBannerContent()) {
      return $r('app.string.ntf_hide_content', 1);
    } else if (this.ntfEntry?.isExpandable) {
      return this.ntfEntry?.notificationContent?.expandedContentText;
    }
    let content = this.ntfEntry?.notificationContent?.contentText;
    if (!content) {
      content = this.ntfEntry?.notificationContent?.contentTitle;
    }
    return content;
  }

  @Builder
  buildTimestamp() {
    // 通知时间
    Text(this.timeVm.timeText)
      .draggable(false)
      .fontSize($r('app.float.ntf_app_time_font_size'))
      .maxFontScale(1)
      .fontColor(this.colorModeVM?.themeTimestampForegroundColor)
      .fontWeight(FontWeight.Regular)
      .maxLines(1)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .id(`TimestampInTint_${this.ntfEntry.hashCode}`)
      .visibility(Visibility.Visible)
      .foregroundBrightness(this.colorModeVM?.themeTimestampForegroundBrightnessOptions)
      .flexShrink(0)
      .width(this.isExpand ? undefined : $r('app.float.ntf_button_size_in_tint'))
      .opacity(this.timeOpacity)
      .translate({ y: this.timeTranslateY })
      .margin({ start: LengthMetrics.resource($r('app.float.ntf_time_end_length')) })
  }

  @Builder
  buildNtfExpandContent() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.End }) {
      if (this.isExpand) {
        Column() {
          if (this.ntfEntry.contentType === NtfMgr.ContentType.NOTIFICATION_CONTENT_MULTILINE) {
            ForEach((this.ntfEntry.notificationContent as NtfMultiLineContent).linesText.slice(0,
              NotificationConfig.ITEM_CONTENT_MAX_LINE_PHONE), (item: string, index?: number) => {
              this.buildNtfMultiLine(item);
            }, (item: string) => {
              return item;
            })
          } else {
            Text(this.getNtfContent())
              .maxLines(NotificationConfig.ITEM_CONTENT_MAX_LINE_PHONE)
              .draggable(false)
              .wordBreak(WordBreak.BREAK_ALL)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontWeight(FontWeight.Regular)
              .fontSize(this.fontScaleState.getScaleSize($r('app.float.ntf_title_font_size')))
              .fontColor(this.colorModeVM?.ntfThemeTextSecondaryColor)
              .foregroundBrightness(this.colorModeVM?.themeFontForegroundOptions)
              .lineHeight(this.fontScaleState.getScaleSize($r('app.float.ntf_text_line_height')))
              .opacity(CONTENT_OPACITY)
          }
        }
        .alignItems(HorizontalAlign.Start)
        .transition(this.transitionEffect)
        .padding({
          top: LengthMetrics.vp(2),
          bottom: LengthMetrics.vp(6)
        })
        .flexGrow(1)
        .flexShrink(1)

        if (this.ntfEntry.largeIcon && !this.isHiddenBannerContent()) {
          Image(this.ntfEntry.largeIcon)
            .id(TAG + '_Image')
            .draggable(false)
            .objectFit(ImageFit.Cover)
            .width($r('app.float.ntf_item_right_icon_size'))
            .height($r('app.float.ntf_item_right_icon_size'))
            .borderRadius($r('app.float.ntf_item_right_icon_radius'))
            .flexShrink(0)
            .interpolation(ImageInterpolation.Medium)
            .autoResize(false)
            .margin({
              start: LengthMetrics.resource($r('app.float.tint_ntf_subtitle_padding_end')),
              top: LengthMetrics.vp(2)
            })
        }
      }

      if (!this.protectedVm.isProtected(this.ntfEntry.bundleIdxTag) && !this.isHiddenBannerContent() &&
        !this.isExpand) {
        Stack({ alignContent: Alignment.Center }) {
          this.arrowDownChild()
        }
        .flexShrink(0)
        .onClick(() => {
          if (!this.isExpand) {
            this.expendAnimate();
          }
        })
        .visibility(this.isContentOverMaxLine ? Visibility.Visible : Visibility.Hidden)
      }
    }
    .padding({ top: this.isMove ? this.fontScaleState.getScaleSize($r('app.float.ntf_text_line_height')) : undefined })
    .margin({ top: this.isExpand ? $r('app.float.ntf_heads_up_drop_margin_bottom') : 0 })
    .height(undefined)
    .animation({ curve: curves.springCurve(0, 1, 225, 25) })
  }

  checkHasArrow(): boolean {
    return !this.protectedVm.isProtected(this.ntfEntry.bundleIdxTag) && !this.isHiddenBannerContent() &&
      !this.isExpand && this.isContentOverMaxLine;
  }

  @Builder
  buildAppIconPortrait() {
    Stack() {
      if ((!this.protectedVm.isProtected(this.ntfEntry.bundleIdxTag) && !this.isHiddenBannerContent() &&
        this.ntfEntry?.overlayIcon) ||
        this.ntfEntry.overlayIconStyle === OverlayIconStyle.REVERSE) {
        // 对话通知图标
        Image(this.ntfEntry.overlayIconStyle !== OverlayIconStyle.REVERSE ? this.ntfEntry.overlayIcon :
        this.ntfEntry?.getAppIcon(true))
          .draggable(false)
          .objectFit(ImageFit.Contain)
          .width(this.iconSize)
          .height(this.iconSize)
          .border(this.ntfEntry.overlayIconStyle !== OverlayIconStyle.REVERSE ?
          notificationStyle.defaultIconBorder(this.iconSize) : undefined)
          .autoResize(false)
          .interpolation(ImageInterpolation.Medium)
      }
      if (this.ntfEntry.overlayIconStyle !== OverlayIconStyle.REVERSE) {
        Image(this.ntfEntry?.getAppIcon(false,
          this.protectedVm.isProtected(this.ntfEntry.bundleIdxTag) || this.isHiddenBannerContent()))
          .draggable(false)
        .objectFit(ImageFit.Contain)
        .width(this.appIconSize)
        .height(this.appIconSize)
        .offset({ x: this.appIconOffset, y: this.appIconOffset })
        .autoResize(true)
        .interpolation(ImageInterpolation.Medium)
      }
    }
    .flexShrink(0)
    .width(this.iconSize)
    .height(this.iconSize)
  }

  @Builder
  buildAppIcon() {
    Image(this.ntfEntry?.getAppIcon(false,
      this.protectedVm.isProtected(this.ntfEntry.bundleIdxTag) || this.isHiddenBannerContent()))
      .draggable(false)
      .objectFit(ImageFit.Contain)
      .width(this.iconSize)
      .height(this.iconSize)
      .autoResize(false)
      .interpolation(ImageInterpolation.Medium)
  }

  @Builder
  buildNtfMultiLine(content: ResourceStr) {
    Text(content)
      .draggable(false)
      .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .fontWeight(FontWeight.Regular)
      .fontSize(this.fontScaleState.getScaleSize($r('app.float.ntf_title_font_size')))
      .fontFeature('\"ss08\" on')
      .fontColor(this.colorModeVM?.ntfThemeTextSecondaryColor)
      .foregroundBrightness(this.colorModeVM?.themeFontForegroundOptions)
      .lineHeight(this.fontScaleState.getScaleSize($r('app.float.ntf_text_line_height')))
      .wordBreak(WordBreak.BREAK_ALL)
  }

  /**
   * 横幅通知展开动画
   */
  private expendAnimate: () => void = () => {
    // 动画第一阶段,位移
    animateTo({
      duration: TRANSLATE_DURATION,
      curve: TRANSLATE_ANIM,
    }, () => {
      this.isExpand = true;
      this.isMove = true;
      this.iconSize = $r('app.float.ntf_small_icon_size_phone');
      this.appIconSize = this.ntfEntry?.overlayIcon ? $r('app.float.ntf_small_icon_with_overlay_icon_size_phone') : this.iconSize;
      this.appIconOffset = this.ntfEntry?.overlayIcon ? $r('app.float.ntf_small_icon_offset_phone') : 0;
      this.subtitleTranslateY = CONTENT_TRANSLATE_Y;
      this.subtitleTranslateX = -7;
      this.timeTranslateY = CONTENT_TRANSLATE_Y;
    });

    // 动画第二阶段，展开
    animateTo({
      duration: OPACITY_DURATION,
      delay: 50,
      curve: OPACITY_ANIM,
    }, () => {
      this.subtitleOpacity = 0;
      this.timeOpacity = TIME_TITLE_OPACITY;
      this.timeTranslateY = 0;
    });
  }
  /**
   * 横幅通知折叠动画
   */
  private foldAnimate: () => void = () => {
    // 动画第一阶段，位移
    animateTo({
      duration: TRANSLATE_DURATION,
      curve: TRANSLATE_ANIM,
      onFinish: () => {
        this.timeTranslateY = 0;
      }
    }, () => {
      this.isMove = false;
      this.isExpand = false;
      this.iconSize = $r('app.float.ntf_small_icon_size_in_tint');
      this.appIconSize = this.ntfEntry?.overlayIcon ? $r('app.float.ntf_small_iconn_with_overlay_icon_size_in_tint') : this.iconSize;
      this.appIconOffset = this.ntfEntry?.overlayIcon ? $r('app.float.ntf_small_icon_in_tint_offset_phone') : 0;
      this.subtitleTranslateY = 0;
      this.subtitleTranslateX = 0;
      this.timeTranslateY = CONTENT_TRANSLATE_Y;
    });

    // 动画第二阶段
    animateTo({
      duration: OPACITY_DURATION,
      delay: 30,
      curve: OPACITY_ANIM,
    }, () => {
      this.subtitleOpacity = SUB_TITLE_OPACITY;
      this.timeOpacity = 0;
    });
  }

  private checkOverMaxLine(): boolean {
    if (!ArrayUtils.isEmpty(this.ntfEntry?.actionButtons) ||
      this.ntfEntry?.contentType !== NtfMgr.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT || this.ntfEntry?.largeIcon) {
      return true;
    }
    const bannerWidth = (DeviceHelper.isPC()) ? BANNER_WIDTH : this.itemWidth;
    // 标题和内容占用的长度
    const paddingWidth = ResUtils.getNumber($r('app.float.ntf_item_padding_start_end'));
    const contentPadding = ResUtils.getNumber($r('app.float.tint_ntf_title_padding_end'));
    const remainWidth = bannerWidth - paddingWidth * 3 - ResUtils.getNumber(this.iconSize);
    // 计算标题长度
    const titleSize: SizeOptions = this.getTextSizeOptions(
      this.isHiddenBannerContent() ? this.appName?.value : this.ntfEntry?.notificationContent?.contentTitle,
      NotificationConfig.ITEM_CONTENT_SINGLE_LINE, FontWeight.Medium);
    // 计算内容最大显示宽度
    const contentMaxWidth: number = remainWidth - ArkUIAdapter.px2vp(Number(titleSize.width)) - contentPadding;
    // 计算单行显示时内容宽度
    const contentOneLineSize: SizeOptions =
      this.getTextSizeOptions(this.getNtfContent(), NotificationConfig.ITEM_CONTENT_SINGLE_LINE, FontWeight.Regular);
    const contentOneLineWidth = ArkUIAdapter.px2vp(Number(contentOneLineSize.width));
    // 若一行展示不完则需要显示"展开按钮"
    return contentOneLineWidth > contentMaxWidth;
  }

  private getTextSizeOptions(textContent: string | Resource | undefined, maxLines: number, fontWeight: FontWeight,
    constraintWidth?: number): SizeOptions {
    return measure.measureTextSize({
      textContent: textContent,
      maxLines: maxLines,
      overflow: TextOverflow.Ellipsis,
      fontWeight: fontWeight,
      fontSize: this.fontScaleState.getScaleSize($r('app.float.ntf_title_font_size')),
      lineHeight: this.fontScaleState.getScaleSize($r('app.float.ntf_text_line_height')),
      constraintWidth: constraintWidth
    });
  }

  private shouldShowActionButtons(): boolean {
    return this.isExpand && !this.isHiddenBannerContent();
  }

  private getActionBtnHeight(isWithActionButtons: boolean): number {
    if (isWithActionButtons && this.shouldShowActionButtons()) {
      return NotificationUtils.getActionBtnHeight(true);
    }
    return 0;
  }

  /**
   * 获取标题长度
   * 如果标题长度小于组件除去内容的长度，则按标题本身长度截断，内容正常展示。反之，组件长度截断，标题末尾用省略号表示，内容不展示
   */
  private getTitleLength(): number | undefined {
    if (this.isExpand) {
      return undefined;
    }
    // 计算文本省略号和间隔（8vp）的大小
    const gap = LengthMetrics.resource($r('app.float.tint_ntf_title_padding_end'))['value']
    const ellipsesGapLength =
      ArkUIAdapter.px2vp(Number(this.getTextSizeOptions('...', 1, FontWeight.Regular)['width'])) + gap;
    // 获取横幅内除去显示组件（内容和标题）的各空间大小
    const iconLeft = LengthMetrics.resource($r('app.float.ntf_icon_Left_length'))['value']
    const iconRight = LengthMetrics.resource($r('app.float.ntf_icon_right_length'))['value']
    const iconSize = LengthMetrics.resource($r('app.float.ntf_small_icon_size_in_tint'))['value']
    const buttonSize = LengthMetrics.resource($r('app.float.ntf_button_size_in_tint'))['value']
    const buttonRight = LengthMetrics.resource($r('app.float.ntf_button_right_length'))['value']
    const buttonLeft = LengthMetrics.resource($r('app.float.ntf_button_left_length'))['value']
    // 计算标题和文本所在的Flex组件大小
    const titleAndContentLength =
      this.itemWidth - iconLeft - iconRight - iconSize - buttonSize - buttonRight - buttonLeft
    // 获取除去文本省略号的标题预留空间
    const excludeContent = titleAndContentLength - ellipsesGapLength
    // 获取标题长度并进行判断
    const titleLength = ArkUIAdapter.px2vp(Number(this.getTextSizeOptions(
      this.ntfEntry?.notificationContent?.contentTitle,
      1,
      FontWeight.Medium)['width']));
    if (titleLength < excludeContent) {
      return titleLength
    } else {
      return titleAndContentLength
    }
  }
}