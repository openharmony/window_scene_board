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

import { ResUtils } from '@ohos/windowscene';
import { CommonUtils } from '@ohos/basicutils';
import {
  CardShowType,
  CARD_ALL_TYPE,
  CardStyleSuffix,
  ImmStyleConfigH,
  SlCardConfigStateV2,
  SlImmConfigStateV2
} from '@ohos/immersivekeyguard';
import { BaseState, SlStateMgr, SlCardStaticStPt, StateModeId } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import {
  SizeBpSplice,
  WBaseProperty
} from '@ohos/screenlockcommon';
import { WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { FontScaleState } from '@ohos/systemuicommon';
import { BrightnessOptionUtils, LiveStyle } from '@ohos/systemuicommon/Index';
import { CardStyleConfigH } from '@ohos/immersivekeyguard/src/main/ets/model/helper/CardStyleConfigHelper';

// 小外屏，沉浸模块配置，只启用沉浸大卡
const OUTER_IMM_DEFAULT_CONFIG = BaseState.wrap<SlImmConfigStateV2>(SlImmConfigStateV2)
  .setListEnable(false).setCapEnable(false).setCardEnable(true);

// 沉浸大卡默认配置
const OUTER_CARD_DEFAULT_CONFIG = BaseState.wrap<SlCardConfigStateV2>(SlCardConfigStateV2, SizeBpSplice.DEFAULT)
  .setTopClockHeight(0).setBottomToolsHeight(0).setBackBtnEnable(true).setLiveBgBlurEnable(true)
  .setContentFullEnable(true).setHideAuthImg(true).setItemClickInner(true).setLiveCachePosEnable(true)
  .setClockHeightDisable(true).setItemGestureDisable(true).setFoldOuter(true).setHideItemBg(true)
  .setLiveArrowEnable(true).setLiveGestureEnable(true);

// 沉浸大卡默认样式
const OUTER_CARD_DEFAULT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setWidth('100%').setHeight('100%');

// 大卡条目布局默认样式，小外屏不显示背景，不涉及提亮参数
const OUTER_CARD_DEFAULT_ITEM_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setEnable(false)
  .setBorderRadiusTL(20)
  .setPointLight({illuminated: IlluminatedType.BORDER});

// 大卡条目布局内容大卡样式
const OUTER_CARD_CONTENT_ITEM_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setEnable(true)
  .setBorderRadiusTL(20)
  .setPointLight({illuminated: IlluminatedType.BORDER});

// 大卡通用布局inner默认模式下样式
const OUTER_CARD_INNER_DEFAULT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DEFAULT)
  .setBgColor($r('sys.color.ohos_id_color_sub_background'));

// 大卡通用布局inner AOD下样式
const OUTER_CARD_INNER_AOD_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setBgColor(Color.Transparent)
  .addChildState(
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setAlpha(0.9)
  );

// 小外屏设备，沉浸大卡通用布局inner样式配置
const OUTER_CARD_INNER_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setBorderRadiusTL(20) // 背景切圆角
  .addChildState(OUTER_CARD_INNER_DEFAULT_STYLE)
  .addChildState(OUTER_CARD_INNER_AOD_STYLE);

// 小外屏设备，大卡通用布局实况卡片AOD下样式
const OUTER_CARD_LIVE_AOD_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setBgColor('#ff242424');

// 小外屏设备，大卡通用布局实况卡片收拢下样式
const OUTER_CARD_LIVE_FOLD_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.LIVE_FOLD)
  .setMarkAnchor({ y: '-100%' });

// 小外屏设备，沉浸大卡通用布局实况卡片样式配置
const OUTER_CARD_LIVE_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setBorderRadiusTL(20).setMarginL(24).setMarginR(24).setMarginB(24)
  .setPaddingL(4).setPaddingR(4).setPaddingB(10).setZIndex(10)
  // 实况卡片展开状态
  .setMarkAnchor({ y: 0 })
  // 小外屏导航图标保持固定过滤颜色
  .setColorFilter(LiveStyle.WHITE_COLOR_FILTER)
  .addChildState(OUTER_CARD_LIVE_AOD_STYLE)
  .addChildState(OUTER_CARD_LIVE_FOLD_STYLE);

// 小外屏设备，大卡通用布局实况卡片提亮背景默认模式下样式
const OUTER_BRIGHT_BG_DEFAULT = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DEFAULT)
  .setBgColor('rgba(0, 0, 0, 1)')
  .setBgBlurStyle(BlurStyle.Regular)
  .setBgBrightnessInner(BrightnessOptionUtils.bannerCardDarkOption);

// 小外屏设备，大卡通用布局实况卡片提亮背景AOD下样式
const OUTER_BRIGHT_BG_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setBgBlurStyle(BlurStyle.NONE)
  .buildCfgPtNull(WBaseProperty.BACKGROUND_COLOR)
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 小外屏设备，沉浸大卡通用布局实况卡片提亮背景样式配置
const OUTER_CARD_BRIGHT_BG_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState(OUTER_BRIGHT_BG_DEFAULT)
  .addChildState(OUTER_BRIGHT_BG_AOD);

// 小外屏设备，大卡通用布局实况卡片线性渐变背景默认模式下样式
const OUTER_LINEAR_BG_DEFAULT = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DEFAULT)
  .setBgColor('rgba(0, 0, 0, 0.1)')
  .setLinearGradient({
    direction: GradientDirection.Top,
    colors: [['rgba(0, 0, 0, 0)', 0], ['rgba(0, 0, 0, 0)', 1]]
  });

// 小外屏设备，大卡通用布局实况卡片线性渐变背景AOD下样式
const OUTER_LINEAR_BG_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .buildCfgPtNull(WBaseProperty.BACKGROUND_COLOR)
  .buildCfgPtNull(WBaseProperty.LINEAR_GRADIENT);

// 小外屏设备，沉浸大卡通用布局实况卡片线性渐变背景样式配置
const OUTER_CARD_LINEAR_BG_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState(OUTER_LINEAR_BG_DEFAULT)
  .addChildState(OUTER_LINEAR_BG_AOD);

// 小外屏设备，沉浸大卡定位权限授权样式配置
const OUTER_CARD_AUTH_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setMarginL(24).setMarginR(24).setMarginB(24).setMarginT(63) // 默认间距
  .setWidth('calc(100% - 48vp)') // 宽度排除左右间距
  .setMaxFontScale(FontScaleState.cardTipMaxScale); // 默认最大字体缩放

// 大卡条目布局返回按钮默认模式下样式
const OUTER_CARD_BACK_DEFAULT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DEFAULT)
  .setBgColor('#ff000000')
  .setBgBrightnessInner(BrightnessOptionUtils.bannerCardDarkOption)
  .setFgColor('#0dffffff')
  .setFgBrightness(BrightnessOptionUtils.getInstance().foregroundSecondaryDarkOption);

// 大卡条目布局返回按钮AOD下样式
const OUTER_CARD_BACK_AOD_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setAlpha(0);

// 大卡条目布局返回按钮纯色下默认背景样式，保持固定颜色
const OUTER_CARD_BACK_SOLID_DEFAULT = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DEFAULT)
  .setBgColor('#0d000000')
  .setFgColor('#0dffffff')
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS)
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 大卡条目布局返回按钮禁用提亮下默认背景样式
const OUTER_CARD_BACK_BRIGHT_DEFAULT = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DEFAULT)
  .setBgColor('#0d000000')
  .setFgColor('#0dffffff')
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS)
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 小外屏设备，大卡条目布局返回按钮样式配置
const OUTER_CARD_BACK_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setWidth(16).setHeight(16)
  .setBgWidth(28).setBgHeight(28)
  .setBorderRadiusTL(14)
  .setMarginT(36).setMarginL(16)
  // 返回按钮模糊参数
  .setBgEffect({
    policy: BlurStyleActivePolicy.ALWAYS_ACTIVE,
    radius: 10,
    brightness: 1.01,
    blurOptions: { grayscale: [38, 38] }
  })
  .setAccessibilityLevel('yes')
  .setAccessibilityText($r('app.string.psd_back_accessible'))
  .addChildState(OUTER_CARD_BACK_DEFAULT_STYLE)
  .addChildState(OUTER_CARD_BACK_AOD_STYLE)
  .addChildState( // 纯色模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.SOLID)
      .setConfigId(SlCardStaticStPt.PT_BACK_BTN_SOLID_COLOR) // 配置标识-大卡返回按钮纯色
      .addChildState(OUTER_CARD_BACK_SOLID_DEFAULT)
  )
  .addChildState( // 禁用提亮模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DIS_BRIGHT)
      .addChildState(OUTER_CARD_BACK_BRIGHT_DEFAULT)
  );

// 小外屏设备，大卡预览图区域AOD样式（静态图/UIExtension）
const OUTER_PREVIEW_AOD_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setAlpha(0); // 大图的透明度

// 小外屏设备，大卡预览图样式
const OUTER_CARD_PREVIEW_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState(OUTER_PREVIEW_AOD_STYLE);

// 小外屏设备，沉浸大卡通用布局实况卡片副文本样式配置
const OUTER_LIVE_RICH_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  // 其他场景复用副文本颜色，AOD场景固定颜色
  .addChildState( // AOD下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setFontColor('#66ffffff')
  );

// 小外屏设备，沉浸大卡通用布局实况卡片箭头收拢样式配置
const OUTER_LIVE_FOLD_ARROW = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.LIVE_FOLD)
  .setAccessibilityText($r('app.string.immersive_card_tip_to_up'))
  .setImgSrc($r('app.media.card_tip_up'));

// 小外屏设备，沉浸大卡通用布局实况卡片箭头样式配置
const OUTER_LIVE_ARROW_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setWidth(48).setHeight(18).setFillColor('#ffffffff').setMarginT(3).setMarginB(3)
  .setAccessibilityText($r('app.string.immersive_card_tip_to_down'))
  .setImgSrc($r('app.media.card_tip_down'))
  .addChildState(OUTER_LIVE_FOLD_ARROW);

// 小外屏设备，大卡通用布局实况卡片主文本样式
const OUTER_CARD_MAIN_TEXT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setFontWeight(FontWeight.Bold)
  // 小外屏固定颜色
  .setFontColor(LiveStyle.LIVE_CARD_TITLE_FONT_COLOR)
  // 小外屏固定字体大小
  .setFontSize(CommonUtils.spliceVp(ResUtils.getNumber($r('sys.float.ohos_id_text_size_body2'))))
  .addChildState( // AOD下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setFontColor('#66ffffff')
  );

// 小外屏设备，大卡通用布局实况卡片副文本样式
const OUTER_CARD_SECONDARY_TEXT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  // 小外屏固定颜色
  .setFontColor(LiveStyle.LIVE_CARD_TEXT_FONT_COLOR)
  // 小外屏固定字体大小
  .setFontSize(CommonUtils.spliceVp(ResUtils.getNumber($r('sys.float.ohos_id_text_size_body3'))))
  .addChildState(// AOD下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setFontColor('#4DFFFFFF')
  );

// 小外屏设备，系统大卡通用布局主文本样式
const OUTER_SYS_MAIN_TEXT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setFontWeight(FontWeight.Medium)
  // 小外屏固定颜色
  .setFontColor(LiveStyle.LIVE_CARD_TITLE_FONT_COLOR)
  // 小外屏固定字体大小
  .setFontSize(CommonUtils.spliceVp(ResUtils.getNumber($r('sys.float.ohos_id_text_size_sub_title3'))))
  .addChildState(// AOD下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setFontColor('#66ffffff')
  );

// 小外屏设备，系统大卡通用布局副文本样式
const OUTER_SYS_SECONDARY_TEXT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  // 小外屏固定颜色
  .setFontColor(LiveStyle.LIVE_CARD_TEXT_FONT_COLOR)
  // 小外屏固定字体大小
  .setFontSize(CommonUtils.spliceVp(ResUtils.getNumber($r('sys.float.ohos_id_text_size_body2'))))
  // 小外屏保持固定提亮
  .setFgBrightness(BrightnessOptionUtils.getInstance().foregroundSecondaryDarkOption)
  .addChildState(// AOD下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setFontColor('#4DFFFFFF')
      .setFgColor('#4DFFFFFF')
      .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS)
  );

// 小外屏设备，三方卡片拓展区样式
const OUTER_OTHER_EXTEND_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState( // AOD下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setAlpha(0.4)
  );

// 小外屏设备，三方卡片拓展区wantAgent样式
const OUTER_OTHER_EXT_WANT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState( // AOD下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setAlpha(0.1)
  );

// 小外屏设备，三方卡片扩展区中文本纯色下AOD样式
const OUTER_OTHER_EXT_TEXT_SOLID_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setBgColor('#66ffffff') // AOD保持独立颜色
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS);

// 小外屏设备，三方卡片扩展区中文本样式
const OUTER_OTHER_EXT_TEXT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState( // AOD下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setFontColor('#66ffffff').setFgBrightness(BrightnessOptionUtils.aodTimeLightOptionForFillColor)
  )
  .addChildState( // 纯色模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.SOLID)
      .addChildState(OUTER_OTHER_EXT_TEXT_SOLID_AOD)
  )
  .addChildState( // 禁用提亮模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DIS_BRIGHT)
      .addChildState(OUTER_OTHER_EXT_TEXT_SOLID_AOD)
  );

// 小外屏设备，三方卡片扩展区中按钮纯色下AOD样式
const OUTER_OTHER_EXT_BTN_SOLID_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setBgColor('#66ffffff') // AOD保持独立颜色
  .setAlpha(0.3)
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 小外屏设备，三方卡片扩展区中按钮样式
const OUTER_OTHER_EXT_BTN_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState( // AOD下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setBgColor('#66ffffff').setBgBrightnessInner(BrightnessOptionUtils.getInstance().aodTimeLightOptionForButtonBgColor)
      .setAlpha(0.3)
  )
  .addChildState( // 纯色模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.SOLID)
      .addChildState(OUTER_OTHER_EXT_BTN_SOLID_AOD)
  )
  .addChildState( // 禁用提亮模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DIS_BRIGHT)
      .addChildState(OUTER_OTHER_EXT_BTN_SOLID_AOD)
  );

// 小外屏设备，三方卡片UIExtension loading组件样式
const OUTER_EXT_LOADING_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setWidth(94)
  .setHeight(94)
  .setItemSpace('8vp')
  .addChildState(// 深色背景下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
      .setBgColor($r('app.color.immersive_card_no_location_dark_bg_color'))
  )
  .addChildState(// 默认浅色背景下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DEFAULT)
      .setBgColor($r('app.color.immersive_card_no_location_bg_color'))
  )
  .addChildState(// AOD下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .buildCfgPtNull(WBaseProperty.BACKGROUND_COLOR)
  );

/**
 * 锁屏V2小外屏样式配置辅助工具
 */
export class SlV2OuterConfigHelper {
  /**
   * 外屏配置初始化
   */
  public initOuterConfig(): void {
    let helper: ImmStyleConfigH = ImmStyleConfigH.getInstance(SlStateMgr.MGR_OUTER_SCREEN);
    helper.setImmConfig(OUTER_IMM_DEFAULT_CONFIG);
    let outerCardHelper: CardStyleConfigH = new CardStyleConfigH();
    outerCardHelper.clearCardConfig();
    outerCardHelper.setCardConfig(OUTER_CARD_DEFAULT_CONFIG);
    outerCardHelper.setCardRootStyle(OUTER_CARD_DEFAULT_STYLE);
    CARD_ALL_TYPE.forEach((cardType) => {
      let isCardContent = cardType === CardShowType.CARD_CONTENT;
      let itemStyle = isCardContent ? OUTER_CARD_CONTENT_ITEM_STYLE : OUTER_CARD_DEFAULT_ITEM_STYLE;
      outerCardHelper.setCardItemStyle(cardType, itemStyle);
    });
    outerCardHelper.setCardComViewStyle(CardStyleSuffix.ITEM_INNER_STYLE, OUTER_CARD_INNER_STYLE);
    outerCardHelper.setCardComViewStyle(CardStyleSuffix.ITEM_LIVE_STYLE, OUTER_CARD_LIVE_STYLE);
    outerCardHelper.setCardComViewStyle(CardStyleSuffix.ITEM_LIVE_ARROW_STYLE, OUTER_LIVE_ARROW_STYLE);
    outerCardHelper.setCardComViewStyle(CardStyleSuffix.ITEM_LINEAR_BG_STYLE, OUTER_CARD_LINEAR_BG_STYLE);
    outerCardHelper.setCardComViewStyle(CardStyleSuffix.ITEM_BRIGHT_BG_STYLE, OUTER_CARD_BRIGHT_BG_STYLE);
    outerCardHelper.setCardComViewStyle(CardStyleSuffix.ITEM_LIVE_RICH_STYLE, OUTER_LIVE_RICH_STYLE);
    outerCardHelper.setCardComViewStyle(CardStyleSuffix.ITEM_AUTH_STYLE, OUTER_CARD_AUTH_STYLE);
    outerCardHelper.setCardComViewStyle(CardStyleSuffix.ITEM_BACK_STYLE, OUTER_CARD_BACK_STYLE);
    outerCardHelper.setCardComViewStyle(CardStyleSuffix.ITEM_PREVIEW_STYLE, OUTER_CARD_PREVIEW_STYLE);
    outerCardHelper.setCardComViewStyle(CardStyleSuffix.ITEM_MAIN_TEXT_STYLE, OUTER_CARD_MAIN_TEXT_STYLE);
    outerCardHelper.setCardComViewStyle(CardStyleSuffix.ITEM_SECONDARY_TEXT_STYLE, OUTER_CARD_SECONDARY_TEXT_STYLE);
    outerCardHelper.setCardComViewStyle(CardStyleSuffix.ITEM_SYS_MAIN_TEXT_STYLE, OUTER_SYS_MAIN_TEXT_STYLE);
    outerCardHelper.setCardComViewStyle(CardStyleSuffix.ITEM_SYS_SECONDARY_TEXT_STYLE, OUTER_SYS_SECONDARY_TEXT_STYLE);
    outerCardHelper.setCardComViewStyle(CardStyleSuffix.ITEM_OTHER_EXTEND_STYLE, OUTER_OTHER_EXTEND_STYLE);
    outerCardHelper.setCardComViewStyle(CardStyleSuffix.ITEM_OTHER_EXTEND_WANT_STYLE, OUTER_OTHER_EXT_WANT_STYLE);
    outerCardHelper.setCardComViewStyle(CardStyleSuffix.ITEM_OTHER_EXTEND_TEXT_STYLE, OUTER_OTHER_EXT_TEXT_STYLE);
    outerCardHelper.setCardComViewStyle(CardStyleSuffix.ITEM_OTHER_EXTEND_BTN_STYLE, OUTER_OTHER_EXT_BTN_STYLE);
    outerCardHelper.setCardComViewStyle(CardStyleSuffix.ITEM_EXTENSION_LOADING_STYLE, OUTER_EXT_LOADING_STYLE);
    helper.setCardConfigHelper(outerCardHelper);
  }
}