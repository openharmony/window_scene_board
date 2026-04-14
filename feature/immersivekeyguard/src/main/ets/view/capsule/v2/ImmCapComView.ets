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
import { LengthMetrics } from '@kit.ArkUI';
import { AccessibilityAppName } from '@ohos/systemuicommon/Index';
import { LiveNotification,
  LiveCardSystemProgressView,
  LiveCardSystemButtonView,
  LiveCardOtherExtendView } from '@ohos/systemuicommon/newIndex';
import { IBaseState, SlComBinStPt } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { WidgetAnimStateV2, WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { CapFadeTextStyle, CapItemId } from '../../../common/constants/CapsuleLayoutStyle';
import { ImmCapData } from '../../../model/data/v2/ImmCapData';
import { v2Helper } from '../../../viewmodel/v2/helper/ImmersiveV2Helper';
import { ImmersiveNtfVmInjector } from '../../../viewmodel/v2/injector/ImmersiveNtfVmInjector';
import { ImmersiveLiveVmInjector } from '../../../viewmodel/v2/injector/ImmersiveLiveVmInjector';
import { CapAnimSuffix, CapStyleSuffix } from '../../../common/constants/ImmCapConst';
import { IImmersiveLiveSysBtnVm } from '../../../common/interface/IImmersiveLiveSysBtnVm';
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';

// 图标通用样式
@Extend(Image)
function iconStyles() {
  .objectFit(ImageFit.Contain)
  .draggable(false)
  .syncLoad(true)
  .autoResize(false)
  .interpolation(ImageInterpolation.Medium)
}

/**
 * V2装饰器，沉浸胶囊通用样式
 */
@ComponentV2
export struct ImmCapComView {
  // 沉浸模块普通通知业务能力注入器
  @Consumer() ntfVmInjector: ImmersiveNtfVmInjector = v2Helper.defaultNtfInjector;

  // 沉浸模块实况通知业务能力注入器
  @Consumer() liveVmInjector: ImmersiveLiveVmInjector = v2Helper.defaultLiveInjector;

  // 胶囊数据
  @Require @Param capData: ImmCapData;

  // 锁屏通用UI绑定状态
  @Computed get slComBind(): IBaseState | undefined {
    return this.ntfVmInjector?.getPanelVm()?.getSlComBindState();
  }

  // 胶囊条目样式
  @Computed get itemStyle(): WidgetStyleStateV2 | undefined {
    return this.getCapStyle(CapStyleSuffix.ITEM_COMMON_STYLE);
  }

  // 胶囊条目inner动效
  @Computed get itemInnerAnim(): WidgetAnimStateV2 | undefined {
    return this.getCapAnim(CapAnimSuffix.ITEM_INNER_ANIM);
  }

  // 大图标样式
  @Computed get lIconStyle(): WidgetStyleStateV2 | undefined {
    return this.getCapStyle(CapStyleSuffix.ITEM_LARGE_ICON_STYLE);
  }

  // 小图标样式
  @Computed get sIconStyle(): WidgetStyleStateV2 | undefined {
    // 区分通用样式
    let suffix = this.capData?.isOverlyReverse() ?
      CapStyleSuffix.ITEM_SMALL_ICON_REVERSE_STYLE : CapStyleSuffix.ITEM_SMALL_ICON_STYLE;
    return this.getCapStyle(suffix);
  }

  // 小图标背景样式
  @Computed get sIconBgStyle(): WidgetStyleStateV2 | undefined {
    // 区分通用样式
    let suffix = this.capData?.isOverlyReverse() ?
      CapStyleSuffix.ITEM_SMALL_ICON_BG_REVERSE_STYLE : CapStyleSuffix.ITEM_SMALL_ICON_BG_STYLE;
    return this.getCapStyle(suffix);
  }

  // 主要文本样式
  @Computed get mainTextStyle(): WidgetStyleStateV2 | undefined {
    return this.getCapStyle(CapStyleSuffix.ITEM_MAIN_TEXT_STYLE);
  }

  // 次要文本样式
  @Computed get secondaryTextStyle(): WidgetStyleStateV2 | undefined {
    return this.getCapStyle(CapStyleSuffix.ITEM_SECONDARY_TEXT_STYLE);
  }

  // 扩展区样式
  @Computed get extensionStyle(): WidgetStyleStateV2 | undefined {
    return this.getCapStyle(CapStyleSuffix.ITEM_EXTENSION_STYLE);
  }

  // 系统实况按钮VM
  @Computed get sysBtnVm(): IImmersiveLiveSysBtnVm | undefined {
    if (this.capData?.isLiveData()) {
      return this.liveVmInjector?.getCardSystemButtonVm(this.capData?.getOriData() as LiveNotification);
    }
    return undefined;
  }

  aboutToAppear(): void {
    // 上树挂载时，实况数据加入注入器
    if (this.capData?.isLiveData()) {
      this.capData.setLiveVmInjector(this.liveVmInjector);
    }
  }

  aboutToDisappear(): void {
    // 下树解挂时，实况数据移除注入器
    if (this.capData?.isLiveData()) {
      this.capData.setLiveVmInjector();
    }
  }

  /**
   * 大图标通用样式
   */
  @Styles
  private LargeIconStyle() {
    .width(this.lIconStyle?.getWidth())
    .height(this.lIconStyle?.getHeight())
    .borderRadius(this.lIconStyle?.getBorderRadiusTL())
    .alignRules({ center: { anchor: CapItemId.ROOT_ID, align: VerticalAlign.Center } })
    .margin({
      top: LengthMetrics.vp(this.lIconStyle?.getMarginT()),
      bottom: LengthMetrics.vp(this.lIconStyle?.getMarginB())
    })
    .opacity(this.lIconStyle?.getAlpha())
  }

  /**
   * 小图标通用样式
   */
  @Styles
  private SmallIconStyle() {
    .width(this.sIconStyle?.getWidth())
    .height(this.sIconStyle?.getHeight())
    .borderRadius({
      topStart: LengthMetrics.vp(this.sIconStyle?.getBorderRadiusTL()),
      topEnd: LengthMetrics.vp(this.sIconStyle?.getBorderRadiusTR()),
      bottomStart: LengthMetrics.vp(this.sIconStyle?.getBorderRadiusBL()),
      bottomEnd: LengthMetrics.vp(this.sIconStyle?.getBorderRadiusBR())
    })
    .offset({
      start: LengthMetrics.vp(this.sIconStyle?.getOffset()?.x as number),
      top: LengthMetrics.vp(this.sIconStyle?.getOffset()?.y as number)
    })
    .alignRules({
      end: { anchor: CapItemId.LARGE_ICON, align: HorizontalAlign.End },
      bottom: { anchor: CapItemId.LARGE_ICON, align: VerticalAlign.Bottom }
    })
    .opacity(this.sIconStyle?.getAlpha())
  }

  /**
   * 小图标背景通用样式
   */
  @Styles
  private SmallIconBgStyle() {
    .width(this.sIconBgStyle?.getWidth())
    .height(this.sIconBgStyle?.getHeight())
    .borderRadius({
      topStart: LengthMetrics.vp(this.sIconBgStyle?.getBorderRadiusTL()),
      topEnd: LengthMetrics.vp(this.sIconBgStyle?.getBorderRadiusTR()),
      bottomStart: LengthMetrics.vp(this.sIconBgStyle?.getBorderRadiusBL()),
      bottomEnd: LengthMetrics.vp(this.sIconBgStyle?.getBorderRadiusBR())
    })
    .offset({
      start: LengthMetrics.vp(this.sIconBgStyle?.getOffset()?.x as number),
      top: LengthMetrics.vp(this.sIconBgStyle?.getOffset()?.y as number)
    })
    .alignRules({
      end: { anchor: CapItemId.LARGE_ICON, align: HorizontalAlign.End },
      bottom: { anchor: CapItemId.LARGE_ICON, align: VerticalAlign.Bottom }
    })
    .backgroundColor(this.sIconBgStyle?.getBgColor())
    .opacity(this.sIconBgStyle?.getAlpha())
  }

  /**
   * 胶囊左侧图标区域
   */
  @Builder
  private CapIconView() {
    // 大图 + 小图 叠加场景
    if (this.capData?.isShowOverlay()) {
      // 整体图标区域
      RelativeContainer() {
        // 大图标
        Image(this.capData?.getLargeIcon())
          .id(CapItemId.LARGE_ICON)
          .clip(true)
          .colorFilter(this.getLIconColorFilter())
          .iconStyles()
          .LargeIconStyle()

        // 小图标背景
        if (this.sIconBgStyle?.getVisibility() === Visibility.Visible) {
          Stack()
            .SmallIconBgStyle()
        }

        // 小图标
        Image(this.capData?.getSmallIcon())
          .fillColor(this.sIconStyle?.getFillColor())
          .iconStyles()
          .SmallIconStyle()
      }
      .id(CapItemId.ICON_AREA)
      .alignRules({ center: { anchor: CapItemId.ROOT_ID, align: VerticalAlign.Center } })
      .width(this.lIconStyle?.getWidth())
      .height(this.lIconStyle?.getHeight())
      .accessibilityLevel(this.lIconStyle?.getAccessibilityLevel())
      .accessibilityText(this.lIconStyle?.getAccessibilityText())
    } else { // 仅大图场景
      Image(this.capData?.getLargeIcon())
        .id(CapItemId.ICON_AREA)
        .colorFilter(this.getLIconColorFilter())
        .accessibilityLevel(this.lIconStyle?.getAccessibilityLevel())
        .accessibilityText(this.lIconStyle?.getAccessibilityText())
        .iconStyles()
        .LargeIconStyle()
    }
  }

  /**
   * 渐隐文本拼接
   *
   * @param style 文本参数
   */
  @Builder
  private FadeTextView(style: CapFadeTextStyle) {
    Stack({ alignContent: Alignment.TopStart }) {
      if (style.secondaryText) {
        // 主文本 + 副文本 拼接场景
        Row({ space: style.itemSpace }) {
          Text(style.mainText)
            .textAlign(TextAlign.Start)
            .fontWeight(style.mainTextWeight)
            .fontFamily('HarmonyHeiTi')
            .fontSize(style.mainTextSize)
            .minFontSize(style.mainMinFontSize)
            .maxFontSize(style.mainTextSize)
            .minFontScale(style.mainMinScale)
            .maxFontScale(style.mainMaxScale)
            .fontColor(style.mainTextColor)
            .height(style.mainTextHeight)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .draggable(false)
            .fontFeature('\"ss08\" on')
            .wordBreak(WordBreak.BREAK_ALL)
            .foregroundBrightness(style.mainFgBrightness)

          Text(style.secondaryText)
            .textAlign(TextAlign.Start)
            .fontWeight(style.secondaryTextWeight)
            .fontFamily('HarmonyHeiTi')
            .fontSize(style.secondaryTextSize)
            .minFontScale(style.secondaryMinScale)
            .maxFontScale(style.secondaryMaxScale)
            .fontColor(style.secondaryTextColor)
            .height(style.secondaryTextHeight)
            .maxLines(1)
            .layoutWeight(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .draggable(false)
            .fontFeature('\"ss08\" on')
            .wordBreak(WordBreak.BREAK_ALL)
            .foregroundBrightness(style.secondaryFgBrightness)
        }
        .clip(true)
      } else {
        // 主文本 或 副文本 场景
        Text(style.mainText)
          .textAlign(TextAlign.Start)
          .fontWeight(style.mainTextWeight)
          .fontFamily('HarmonyHeiTi')
          .fontSize(style.mainTextSize)
          .minFontSize(style.mainMinFontSize)
          .maxFontSize(style.mainTextSize)
          .minFontScale(style.mainMinScale)
          .maxFontScale(style.mainMaxScale)
          .fontColor(style.mainTextColor)
          .height(style.mainTextHeight)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .draggable(false)
          .fontFeature('\"ss08\" on')
          .wordBreak(WordBreak.BREAK_ALL)
          .foregroundBrightness(style.mainFgBrightness)
      }
    }
    .id(style.textId)
    .visibility(style.isHideText ? Visibility.None : Visibility.Visible)
  }

  /**
   * 胶囊标题内容文本区域
   */
  @Builder
  private CapTitleContentView(isGroup: boolean) {
    // 文本区域保持垂直居中
    Column() {
      // 单通知主标题 或 组通知第一条通知拼接文本
      this.FadeTextView({
        textId: CapItemId.TITLE_TEXT,
        mainText: this.capData?.mainTitle,
        mainTextColor: this.mainTextStyle?.getFontColor(),
        mainTextSize: this.mainTextStyle?.getFontSize(),
        mainMinFontSize: this.mainTextStyle?.getMinFontSize(),
        mainMinScale: this.mainTextStyle?.getMinFontScale(),
        mainMaxScale: this.mainTextStyle?.getMaxFontScale(),
        mainTextHeight: this.mainTextStyle?.getHeight(),
        mainFgBrightness: this.mainTextStyle?.getFgBrightness(),
        mainTextWeight: FontWeight.Medium,
        // 组通知场景，存在副文本拼接
        secondaryText: isGroup ? this.capData?.mainContent : undefined,
        secondaryTextColor: this.secondaryTextStyle?.getFontColor(),
        secondaryTextSize: this.secondaryTextStyle?.getFontSize(),
        secondaryMinScale: this.secondaryTextStyle?.getMinFontScale(),
        secondaryMaxScale: this.secondaryTextStyle?.getMaxFontScale(),
        secondaryTextHeight: this.secondaryTextStyle?.getHeight(),
        secondaryFgBrightness: this.secondaryTextStyle?.getFgBrightness(),
        secondaryTextWeight: FontWeight.Regular,
        // 主标题隐藏
        isHideText: this.capData?.isHideTitleText(),
      })

      // 单通知副文本 或 组通知第二条通知拼接文本
      this.FadeTextView({
        textId: CapItemId.CONTENT_TEXT,
        // 组通知场景 title和content拼接，单通知场景直接content
        mainText: isGroup ? this.capData?.secondaryTitle : this.capData?.mainContent,
        mainTextColor: isGroup ? this.mainTextStyle?.getFontColor() : this.secondaryTextStyle?.getFontColor(),
        mainTextSize: isGroup ? this.mainTextStyle?.getFontSize() : this.secondaryTextStyle?.getFontSize(),
        mainMinFontSize: isGroup ? this.mainTextStyle?.getMinFontSize() : undefined,
        mainMinScale: isGroup ? this.mainTextStyle?.getMinFontScale() : this.secondaryTextStyle?.getMinFontScale(),
        mainMaxScale: isGroup ? this.mainTextStyle?.getMaxFontScale() : this.secondaryTextStyle?.getMaxFontScale(),
        mainTextHeight: isGroup ? this.mainTextStyle?.getHeight() : this.secondaryTextStyle?.getHeight(),
        mainFgBrightness: isGroup ? this.mainTextStyle?.getFgBrightness() : this.secondaryTextStyle?.getFgBrightness(),
        mainTextWeight: isGroup ? FontWeight.Medium : FontWeight.Regular,
        // 组通知场景，存在副文本拼接
        secondaryText: isGroup ? this.capData?.secondaryContent : undefined,
        secondaryTextColor: this.secondaryTextStyle?.getFontColor(),
        secondaryTextSize: this.secondaryTextStyle?.getFontSize(),
        secondaryMinScale: this.secondaryTextStyle?.getMinFontScale(),
        secondaryMaxScale: this.secondaryTextStyle?.getMaxFontScale(),
        secondaryTextHeight: this.secondaryTextStyle?.getHeight(),
        secondaryFgBrightness: this.secondaryTextStyle?.getFgBrightness(),
        secondaryTextWeight: FontWeight.Regular,
        // 副文本隐藏
        isHideText: this.capData?.isHideContentText(),
      })
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .layoutWeight(1)
    .alignRules({
      start: { anchor: CapItemId.ICON_AREA, align: HorizontalAlign.End },
      end: {
        anchor: this.capData?.isShowExtensionArea() ? CapItemId.EXTEND_AREA : CapItemId.ROOT_ID,
        align: this.capData?.isShowExtensionArea() ? HorizontalAlign.Start : HorizontalAlign.End
      },
      top: {
        anchor: CapItemId.ROOT_ID,
        align: VerticalAlign.Top
      },
      bottom: {
        anchor: CapItemId.ROOT_ID,
        align: VerticalAlign.Bottom
      },
    })
    .margin({
      start: LengthMetrics.vp(this.mainTextStyle?.getMarginL()),
      // 无扩展区时，尾部间距
      end: LengthMetrics.vp(this.capData?.isShowExtensionArea() ? 0 : this.mainTextStyle?.getMarginR())
    })
    .opacity(this.getItemInnerAlpha())
  }

  /**
   * 扩展区域
   */
  @Builder
  private CapExtendView() {
    // 系统实况辅助区
    if (this.capData?.hasSysProgress() || this.capData?.hasSysButton()) {
      Row({ space: this.extensionStyle?.getItemSpace() }) {
        // 进度条
        if (this.capData?.hasSysProgress()) {
          LiveCardSystemProgressView({ live: this.capData?.getOriData() as LiveNotification })
        }
        // 按钮
        if (this.capData?.hasSysButton() && this.sysBtnVm) {
          Repeat(this.capData?.priorityBtn).each((data) => {
            LiveCardSystemButtonView({
              buttons: this.capData?.priorityBtn,
              buttonIndex: data.index,
              buttonVm: this.sysBtnVm as IImmersiveLiveSysBtnVm,
            })
          })
        }
      }
      .id(CapItemId.EXTEND_AREA)
      .clip(true)
      .height(this.extensionStyle?.getHeight())
      .margin({
        top: LengthMetrics.vp(this.extensionStyle?.getMarginT()),
        bottom: LengthMetrics.vp(this.extensionStyle?.getMarginB()),
        start: LengthMetrics.vp(this.extensionStyle?.getMarginL())
      })
      .alignRules({
        // 父布局，靠右垂直居中
        end: { anchor: CapItemId.ROOT_ID, align: HorizontalAlign.End },
        center: { anchor: CapItemId.ROOT_ID, align: VerticalAlign.Center }
      })
      .opacity(this.getBtnAlpha())
    } else if (this.capData?.hasOtherExtension()) {
      // 三方实况辅助区
      LiveCardOtherExtendView({ live: this.capData?.getOriData() as LiveNotification })
        .id(CapItemId.EXTEND_AREA)
        .height(this.extensionStyle?.getHeight())
        .margin({
          top: LengthMetrics.vp(this.extensionStyle?.getMarginT()),
          bottom: LengthMetrics.vp(this.extensionStyle?.getMarginB()),
          start: LengthMetrics.vp(this.extensionStyle?.getMarginL())
        })
        .alignRules({
          // 父布局，靠右垂直居中
          end: { anchor: CapItemId.ROOT_ID, align: HorizontalAlign.End },
          center: { anchor: CapItemId.ROOT_ID, align: VerticalAlign.Center }
        })
        .opacity(this.getExtendAlpha())
    }
  }

  build() {
    if (this.capData) {
      RelativeContainer() {
        // 无沉浸大卡时胶囊的无障碍应用名
        if (!this.capData.isSupportImmCard()) {
          AccessibilityAppName({
            name: this.capData?.getAppName(),
            isAccessibilityMode: this.isAccessibilityMode()
          })
        }

        // 图标区域
        this.CapIconView()

        // 主副文本区域
        this.CapTitleContentView(this.capData.isShowGroupStyle())

        // 扩展区域
        if (this.capData?.isShowExtensionArea()) {
          this.CapExtendView()
        }
      }
      .width(this.getItemInnerWidth())
      .height(this.itemStyle?.getHeight())
      .padding({
        start: LengthMetrics.vp(this.itemStyle?.getPaddingL()),
        end: LengthMetrics.vp(this.itemStyle?.getPaddingR())
      })
    }
  }

  /**
   * 大图标颜色过滤
   *
   * @returns 颜色过滤
   */
  private getLIconColorFilter(): ColorFilter | undefined {
    if (this.capData?.isSupportColorFilter()) {
      return this.lIconStyle?.getColorFilter();
    }
    return undefined;
  }

  /**
   * 获取固定宽度
   *
   * @returns 宽度
   */
  private getItemInnerWidth(): number | string {
    if (this.itemInnerAnim?.isSceneAnimating()) {
      return this.itemInnerAnim?.getWidth() ?? '100%';
    }
    return '100%';
  }

  /**
   * 获取inner透明度
   *
   * @returns 透明度
   */
  private getItemInnerAlpha(): number | undefined {
    if (this.itemInnerAnim?.isWidgetAnimating()) {
      return this.itemInnerAnim.getAlpha();
    }
    return undefined;
  }

  /**
   * 获取按钮区透明度
   *
   * @returns 透明度
   */
  private getBtnAlpha(): number | undefined {
    if (this.itemInnerAnim?.isWidgetAnimating()) {
      return this.itemInnerAnim.getAlpha();
    }
    return undefined;
  }

  /**
   * 获取扩展区透明度
   *
   * @returns 透明度
   */
  private getExtendAlpha(): number | undefined {
    if (this.itemInnerAnim?.isWidgetAnimating()) {
      return this.itemInnerAnim.getAlpha();
    }
    return this.extensionStyle?.getAlpha();
  }

  /**
   * 是否无障碍模式开启
   *
   * @returns true无障碍开启
   */
  private isAccessibilityMode(): boolean {
    return AccessibilityUtil.isAccessibilityMode();
  }

  /**
   * 胶囊样式取值统一管理
   *
   * @param suffix 样式后缀
   * @returns 样式
   */
  private getCapStyle(suffix: CapStyleSuffix): WidgetStyleStateV2 | undefined {
    let helper = this.ntfVmInjector?.getImmItemHelperVm().getCapStyleH(suffix);
    return helper?.getItemSt(this.capData?.getCapShowType());
  }

  /**
   * 胶囊动效取值统一管理
   *
   * @param suffix 动效后缀
   * @returns 样式
   */
  private getCapAnim(suffix: CapAnimSuffix): WidgetAnimStateV2 | undefined {
    let helper = this.ntfVmInjector?.getImmItemHelperVm().getCapAnimH(suffix);
    return helper?.getItemSt(this.capData?.getCapShowType());
  }
}