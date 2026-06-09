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
  SizeBpSplice,
  WBaseProperty
} from '@ohos/screenlockcommon';
import {
  BaseState,
  SlCardStaticStPt,
  SlStateId,
  StateModeId,
} from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { ColumnGutter, StyleStateConfig, WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { FontScaleState } from '@ohos/systemuicommon';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import { CardStyleSuffix } from '../../common/constants/ImmCardConst';
import { ICardStyleConfigHelper } from '../../common/interface/ICardStyleConfigHelper';
import { CalcGutterHeight, SlCardConfigStateV2 } from '../data/v2/SlCardConfigStateV2';
import { SlCardStateConfig } from '../data/v2/SlCardStateConfig';
import { ResUtils } from '@ohos/windowscene';
import { CardShowType } from '../../common/constants/ImmCardConst';

// 沉浸大卡默认栅格高度计算方式
const CARD_CALC_GUTTER_HEIGHT: CalcGutterHeight = (gutterWidth): number => {
  // 栅格高度计算和播控保持一致
  return (gutterWidth - 72) / 2 + 122 + 48;
};

// 沉浸大卡默认配置
const CARD_DEFAULT_CONFIG = BaseState.wrap<SlCardConfigStateV2>(SlCardConfigStateV2, SizeBpSplice.DEFAULT)
  .setTopClockHeight(124).setBottomToolsHeight(0);

// 沉浸大卡大折叠展开态配置
const CARD_MM_CONFIG = BaseState.wrap<SlCardConfigStateV2>(SlCardConfigStateV2, SizeBpSplice.MM)
  .setTopClockHeight(124).setBottomToolsHeight(0)
  .setCalcGutterHeight(CARD_CALC_GUTTER_HEIGHT)
  .setGutterConfig(ColumnGutter.wrap({ maxColumn: 8, margin: 24, gutter: 12 }).updateColumn(6));

// 沉浸大卡PAD横屏配置
const CARD_LS_CONFIG = BaseState.wrap<SlCardConfigStateV2>(SlCardConfigStateV2, SizeBpSplice.LS)
  .setTopClockHeight(124).setBottomToolsHeight(0)
  .setCalcGutterHeight(CARD_CALC_GUTTER_HEIGHT)
  .setGutterConfig(ColumnGutter.wrap({ maxColumn: 12, margin: 32, gutter: 16 }).updateColumn(6));

// 沉浸大卡PAD竖屏配置
const CARD_ML_CONFIG = BaseState.wrap<SlCardConfigStateV2>(SlCardConfigStateV2, SizeBpSplice.ML)
  .setTopClockHeight(124).setBottomToolsHeight(0).setGutterHeightEnable(true)
  .setCalcGutterHeight(CARD_CALC_GUTTER_HEIGHT)
  .setGutterConfig(ColumnGutter.wrap({ maxColumn: 12, margin: 32, gutter: 16 }).updateColumn(6));

// 沉浸大卡默认样式
const CARD_DEFAULT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setPaddingT(16).setPaddingB(16).setPaddingL(16).setPaddingR(16).setWidth('100%').setHeight('100%');

// 沉浸大卡其他样式
const CARD_OTHER_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setPaddingT(16).setPaddingB(16).setWidth('100%').setHeight('100%');

// 大卡条目默认模式下样式
const CARD_ITEM_DEFAULT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DEFAULT)
  .setBgColor('#FF242424')
  .setBgBrightnessInner(BrightnessOptionUtils.keyguardImmersiveCardOption);

// 大卡条目深色模式下样式
const CARD_ITEM_DARK_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .setBgColor('#FF242424')
  .setBgBrightnessInner(BrightnessOptionUtils.keyguardImmersiveDarkCardOption);

// 大卡条目AOD模式下样式
const CARD_ITEM_AOD_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setBgColor('#FF242424')
  .setBgBrightnessInner(BrightnessOptionUtils.aodScreenNtfBaseboardLightOption);

// 大卡条目纯色下深色背景样式
const CARD_ITEM_SOLID_DARK = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 大卡条目纯色下浅色背景样式
const CARD_ITEM_SOLID_LIGHT = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.LIGHT)
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 大卡条目纯色下AOD样式
const CARD_ITEM_SOLID_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setBgColor('#ff242424') // AOD保持独立颜色
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 大卡条目禁用提亮下深色背景样式
const CARD_ITEM_BRIGHT_DARK = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .setUseEffect(false)
  .setBgColor('#24ffffff')
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 大卡条目禁用提亮下浅色背景样式
const CARD_ITEM_BRIGHT_LIGHT = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.LIGHT)
  .setUseEffect(false)
  .setBgColor('#39000000')
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 大卡条目禁用提亮下AOD样式
const CARD_ITEM_BRIGHT_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setUseEffect(false)
  .setBgColor('#ff242424')
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 大卡条目布局默认样式
const CARD_DEFAULT_ITEM_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setEnable(false)
  .setBorderRadiusTL(32)
  .setPointLight({illuminated: IlluminatedType.BORDER})
  .addChildState(CARD_ITEM_DEFAULT_STYLE) // 浅色模式由默认替代
  .addChildState(CARD_ITEM_DARK_STYLE)
  .addChildState(CARD_ITEM_AOD_STYLE)
  .addChildState( // 纯色模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.SOLID)
      .setConfigId(SlCardStaticStPt.PT_CARD_SOLID_BG_COLOR) // 配置标识-大卡背景纯色
      .addChildState(CARD_ITEM_SOLID_DARK)
      .addChildState(CARD_ITEM_SOLID_LIGHT)
      .addChildState(CARD_ITEM_SOLID_AOD)
  )
  .addChildState( // 禁用提亮模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DIS_BRIGHT)
      .addChildState(CARD_ITEM_BRIGHT_DARK)
      .addChildState(CARD_ITEM_BRIGHT_LIGHT)
      .addChildState(CARD_ITEM_BRIGHT_AOD)
  );

// 大卡条目布局内容大卡样式
const CARD_CONTENT_ITEM_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setEnable(true)
  .setBorderRadiusTL(32)
  .setPointLight({illuminated: IlluminatedType.BORDER})
  .addChildState(CARD_ITEM_DEFAULT_STYLE) // 浅色模式由默认替代
  .addChildState(CARD_ITEM_DARK_STYLE)
  .addChildState(CARD_ITEM_AOD_STYLE)
  .addChildState( // 纯色模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.SOLID)
      .setConfigId(SlCardStaticStPt.PT_CARD_SOLID_BG_COLOR) // 配置标识-大卡背景纯色
      .addChildState(CARD_ITEM_SOLID_DARK)
      .addChildState(CARD_ITEM_SOLID_LIGHT)
      .addChildState(CARD_ITEM_SOLID_AOD)
  )
  .addChildState( // 禁用提亮模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DIS_BRIGHT)
      .addChildState(CARD_ITEM_BRIGHT_DARK)
      .addChildState(CARD_ITEM_BRIGHT_LIGHT)
      .addChildState(CARD_ITEM_BRIGHT_AOD)
  );

// 大卡通用布局inner默认样式
const CARD_INNER_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState(
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setAlpha(0.9)
  );

// 大卡条目背景样式
const CARD_BG_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState(
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
    .setAlpha(0.7)
  );

// 大卡通用布局实况卡片AOD样式
const CARD_LIVE_CARD_AOD_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD);

// 大卡通用布局实况卡片默认样式
const CARD_LIVE_CARD_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState(CARD_LIVE_CARD_AOD_STYLE)
  .setZIndex(10)
  .setMarginL(12)
  .setMarginR(12)
  .setMarginB(8);

// 大卡预览图区域AOD样式（静态图/UIExtension/播控通用）
const CARD_DEFAULT_PREVIEW_AOD_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setAlpha(0.4); // 大图的透明度

// 大卡预览图区域样式（静态图/UIExtension/播控通用）
const CARD_DEFAULT_PREVIEW_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState(CARD_DEFAULT_PREVIEW_AOD_STYLE);

// 大卡定位权限授权默认模式下样式
const CARD_AUTH_DEFAULT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DEFAULT)
  .setBgColor($r('sys.color.font_on_tertiary'));

// 大卡定位权限授权深色模式下样式
const CARD_AUTH_DARK_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .setBgColor($r('app.color.immersive_auth_overlay_dark'));

// 大卡定位权限授权默认样式
const CARD_DEFAULT_AUTH_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setMarginL(24).setMarginR(24).setMarginB(16) // 默认间距
  .setMaxFontScale(FontScaleState.cardMaxScale) // 默认最大字体缩放
  .addChildState(CARD_AUTH_DEFAULT_STYLE) // 默认模式下样式
  .addChildState(CARD_AUTH_DARK_STYLE); // 深色模式下样式

// 大卡定位权限授权PAD样式
const CARD_ML_LS_AUTH_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.ML)
  .setMarginL(24).setMarginR(24).setMarginB(16) // 默认间距
  .setMaxFontScale(FontScaleState.cardTipMaxScale) // 默认最大字体缩放
  .addChildState(CARD_AUTH_DEFAULT_STYLE) // 默认模式下样式
  .addChildState(CARD_AUTH_DARK_STYLE); // 深色模式下样式

// 大卡定位权限授权大折叠展开样式
const CARD_MM_AUTH_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.MM)
  .setMarginL(24).setMarginR(24).setMarginB(16) // 默认间距
  .setMaxFontScale(FontScaleState.recentUIMaxScale) // 默认最大字体缩放
  .addChildState(CARD_AUTH_DEFAULT_STYLE) // 默认模式下样式
  .addChildState(CARD_AUTH_DARK_STYLE); // 深色模式下样式

// 大卡条目布局返回按钮默认样式
const CARD_BACK_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT);

// 大卡通用布局主文本样式
const CARD_MAIN_TEXT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setFontWeight(FontWeight.Medium)
  .setFontSize(ResUtils.getNumber($r('sys.float.ohos_id_text_size_headline8')))
  .addChildState( // AOD下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setFontColor('#66ffffff')
  );

// 大卡通用布局副文本样式
const CARD_SECONDARY_TEXT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setFontSize(ResUtils.getNumber($r('sys.float.ohos_id_text_size_body1')))
  .addChildState(// AOD下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setFontColor('#4DFFFFFF')
  );

// 系统大卡通用布局主文本样式
const CARD_SYS_MAIN_TEXT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setFontWeight(FontWeight.Medium)
  .setFontSize(ResUtils.getNumber($r('sys.float.ohos_id_text_size_sub_title3')))
  .addChildState(// AOD下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setFontColor('#66ffffff')
  );

// 系统大卡通用布局副文本样式
const CARD_SYS_SECONDARY_TEXT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setFontSize(ResUtils.getNumber($r('sys.float.ohos_id_text_size_body2')))
  .addChildState(// AOD下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setFontColor('#4DFFFFFF')
  );

// 三方卡片拓展区样式
const CARD_OTHER_EXTEND_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState( // AOD下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setAlpha(0.4)
  );

// 三方卡片拓展区wantAgent样式
const CARD_OTHER_EXTEND_WANT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState( // AOD下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setAlpha(0.1)
  );

// 三方卡片扩展区中文本纯色下AOD样式
const CARD_OTHER_EXT_TEXT_SOLID_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setBgColor('#66ffffff') // AOD保持独立颜色
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS);

// 三方卡片扩展区中文本样式
const CARD_OTHER_EXTEND_TEXT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState( // AOD下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setFontColor('#66ffffff').setFgBrightness(BrightnessOptionUtils.aodTimeLightOptionForFillColor)
  )
  .addChildState( // 纯色模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.SOLID)
      .addChildState(CARD_OTHER_EXT_TEXT_SOLID_AOD)
  )
  .addChildState( // 禁用提亮模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DIS_BRIGHT)
      .addChildState(CARD_OTHER_EXT_TEXT_SOLID_AOD)
  );

// 三方卡片扩展区中按钮纯色下AOD样式
const CARD_OTHER_EXT_BTN_SOLID_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setBgColor('#66ffffff') // AOD保持独立颜色
  .setAlpha(0.3)
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 三方卡片扩展区中按钮样式
const CARD_OTHER_EXTEND_BTN_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState( // AOD下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setBgColor('#66ffffff').setBgBrightnessInner(BrightnessOptionUtils.getInstance().aodTimeLightOptionForButtonBgColor)
      .setAlpha(0.3)
  )
  .addChildState( // 纯色模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.SOLID)
      .addChildState(CARD_OTHER_EXT_BTN_SOLID_AOD)
  )
  .addChildState( // 禁用提亮模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DIS_BRIGHT)
      .addChildState(CARD_OTHER_EXT_BTN_SOLID_AOD)
  );

// 三方卡片UIExtension loading组件样式
const CARD_EXTEND_LOADING_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
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
 * 沉浸大卡样式默认配置辅助工具
 */
export class CardStyleConfigH implements ICardStyleConfigHelper {
  // 沉浸大卡扩展配置
  private readonly cardConfig: SlCardStateConfig = SlCardStateConfig.wrap(SlStateId.SL_CARD_STATE)
    .bindBpConfig(SizeBpSplice.DEFAULT, CARD_DEFAULT_CONFIG)
    .bindBpConfig(SizeBpSplice.MM, CARD_MM_CONFIG)
    .bindBpConfig(SizeBpSplice.LS, CARD_LS_CONFIG)
    .bindBpConfig(SizeBpSplice.XS, CARD_LS_CONFIG)
    .bindBpConfig(SizeBpSplice.ML, CARD_ML_CONFIG)
    .bindBpConfig(SizeBpSplice.LL, CARD_ML_CONFIG);

  // 沉浸大卡样式配置
  private readonly cardRootStyle: StyleStateConfig = StyleStateConfig.wrap(SlStateId.SL_CARD_STATE)
    .bindBpConfig(SizeBpSplice.DEFAULT, CARD_DEFAULT_STYLE)
    .bindBpConfig(SizeBpSplice.MM, CARD_OTHER_STYLE) // 大折叠展开
    .bindBpConfig(SizeBpSplice.ML, CARD_OTHER_STYLE) // PAD竖屏
    .bindBpConfig(SizeBpSplice.LL, CARD_OTHER_STYLE) // PAD竖屏
    .bindBpConfig(SizeBpSplice.LS, CARD_OTHER_STYLE) // PAD横屏
    .bindBpConfig(SizeBpSplice.XS, CARD_OTHER_STYLE); // PAD横屏

  // 沉浸大卡条目布局样式配置
  private readonly cardItemStyle: Map<CardShowType, StyleStateConfig> = new Map([
    [CardShowType.CARD_CONTENT, StyleStateConfig.wrap(CardShowType.CARD_CONTENT).bindConfig(CARD_CONTENT_ITEM_STYLE)],
    [CardShowType.CARD_DELETE, StyleStateConfig.wrap(CardShowType.CARD_DELETE).bindConfig(CARD_DEFAULT_ITEM_STYLE)],
    [CardShowType.CARD_CAP, StyleStateConfig.wrap(CardShowType.CARD_CAP).bindConfig(CARD_DEFAULT_ITEM_STYLE)],
    [CardShowType.CARD_LIST, StyleStateConfig.wrap(CardShowType.CARD_LIST).bindConfig(CARD_DEFAULT_ITEM_STYLE)],
    [CardShowType.CARD_UPDATE_OLD, StyleStateConfig.wrap(CardShowType.CARD_UPDATE_OLD)
      .bindConfig(CARD_DEFAULT_ITEM_STYLE)],
    [CardShowType.CARD_UI_EXTENSION_CACHE, StyleStateConfig.wrap(CardShowType.CARD_UI_EXTENSION_CACHE)
      .bindConfig(CARD_DEFAULT_ITEM_STYLE)],
  ]);

  // 沉浸大卡通用布局样式配置
  private readonly cardComViewStyle: Map<CardStyleSuffix, StyleStateConfig> = new Map([
    [ // 内部通用布局inner样式
      CardStyleSuffix.ITEM_INNER_STYLE,
      StyleStateConfig.wrap(CardStyleSuffix.ITEM_INNER_STYLE).bindConfig(CARD_INNER_STYLE)
    ],
    [ // 条目背景样式
      CardStyleSuffix.ITEM_BG_STYLE,
      StyleStateConfig.wrap(CardStyleSuffix.ITEM_BG_STYLE).bindConfig(CARD_BG_STYLE)
    ],
    [ // 内部实况卡片样式
      CardStyleSuffix.ITEM_LIVE_STYLE,
      StyleStateConfig.wrap(CardStyleSuffix.ITEM_LIVE_STYLE).bindConfig(CARD_LIVE_CARD_STYLE)
    ],
    [ // UIExtension定位权限授权样式
      CardStyleSuffix.ITEM_AUTH_STYLE,
      StyleStateConfig.wrap(CardStyleSuffix.ITEM_AUTH_STYLE)
        .bindBpConfig(SizeBpSplice.DEFAULT, CARD_DEFAULT_AUTH_STYLE)
        .bindBpConfig(SizeBpSplice.MM, CARD_MM_AUTH_STYLE)
        .bindBpConfig(SizeBpSplice.ML, CARD_ML_LS_AUTH_STYLE)
        .bindBpConfig(SizeBpSplice.LL, CARD_ML_LS_AUTH_STYLE)
        .bindBpConfig(SizeBpSplice.LS, CARD_ML_LS_AUTH_STYLE)
        .bindBpConfig(SizeBpSplice.XS, CARD_ML_LS_AUTH_STYLE)
    ],
    [ // 条目布局返回按钮样式
      CardStyleSuffix.ITEM_BACK_STYLE,
      StyleStateConfig.wrap(CardStyleSuffix.ITEM_BACK_STYLE).bindConfig(CARD_BACK_STYLE)
    ],
    [ // 大卡预览图区域样式（静态图/UIExtension/播控通用）
      CardStyleSuffix.ITEM_PREVIEW_STYLE,
      StyleStateConfig.wrap(CardStyleSuffix.ITEM_PREVIEW_STYLE).bindConfig(CARD_DEFAULT_PREVIEW_STYLE)
    ],
    [ // 主文本样式
      CardStyleSuffix.ITEM_MAIN_TEXT_STYLE,
      StyleStateConfig.wrap(CardStyleSuffix.ITEM_MAIN_TEXT_STYLE).bindConfig(CARD_MAIN_TEXT_STYLE)
    ],
    [ // 副文本样式
      CardStyleSuffix.ITEM_SECONDARY_TEXT_STYLE,
      StyleStateConfig.wrap(CardStyleSuffix.ITEM_SECONDARY_TEXT_STYLE).bindConfig(CARD_SECONDARY_TEXT_STYLE)
    ],
    [ // 系统实况卡片主文本样式
      CardStyleSuffix.ITEM_SYS_MAIN_TEXT_STYLE,
      StyleStateConfig.wrap(CardStyleSuffix.ITEM_SYS_MAIN_TEXT_STYLE).bindConfig(CARD_SYS_MAIN_TEXT_STYLE)
    ],
    [ // 系统实况卡片副文本样式
      CardStyleSuffix.ITEM_SYS_SECONDARY_TEXT_STYLE,
      StyleStateConfig.wrap(CardStyleSuffix.ITEM_SYS_SECONDARY_TEXT_STYLE).bindConfig(CARD_SYS_SECONDARY_TEXT_STYLE)
    ],
    [ // 三方卡片拓展区样式
      CardStyleSuffix.ITEM_OTHER_EXTEND_STYLE,
      StyleStateConfig.wrap(CardStyleSuffix.ITEM_OTHER_EXTEND_STYLE).bindConfig(CARD_OTHER_EXTEND_STYLE)
    ],
    [ // 三方卡片wantAgent拓展区样式
      CardStyleSuffix.ITEM_OTHER_EXTEND_WANT_STYLE,
      StyleStateConfig.wrap(CardStyleSuffix.ITEM_OTHER_EXTEND_WANT_STYLE).bindConfig(CARD_OTHER_EXTEND_WANT_STYLE)
    ],
    [ // 三方卡片拓展区样式
      CardStyleSuffix.ITEM_OTHER_EXTEND_TEXT_STYLE,
      StyleStateConfig.wrap(CardStyleSuffix.ITEM_OTHER_EXTEND_TEXT_STYLE).bindConfig(CARD_OTHER_EXTEND_TEXT_STYLE)
    ],
    [ // 三方卡片拓展区样式
      CardStyleSuffix.ITEM_OTHER_EXTEND_BTN_STYLE,
      StyleStateConfig.wrap(CardStyleSuffix.ITEM_OTHER_EXTEND_BTN_STYLE).bindConfig(CARD_OTHER_EXTEND_BTN_STYLE)
    ],
    [ // 三方卡片UIExtension loading组件样式
      CardStyleSuffix.ITEM_EXTENSION_LOADING_STYLE,
      StyleStateConfig.wrap(CardStyleSuffix.ITEM_EXTENSION_LOADING_STYLE).bindConfig(CARD_EXTEND_LOADING_STYLE)
    ],
  ]);

  /**
   * 清空沉浸大卡所有配置
   */
  public clearCardConfig(): void {
    this.cardConfig.clearConfig();
    this.cardRootStyle.clearConfig();
    this.cardItemStyle.clear();
    this.cardComViewStyle.clear();
  }

  /**
   * 赋值沉浸大卡配置，用于多产品差异化配置
   *
   * @param config 配置
   */
  public setCardConfig(config: SlCardConfigStateV2): void {
    if (config) {
      this.cardConfig.bindBpConfig(config.getBpSplice(), config);
    }
  }

  /**
   * 赋值沉浸大卡root布局样式配置，用于多产品差异化配置
   *
   * @param style 样式配置
   */
  public setCardRootStyle(style: WidgetStyleStateV2): void {
    if (style) {
      this.cardRootStyle.bindBpConfig(style.getBpSplice(), style);
    }
  }

  /**
   * 赋值沉浸大卡条目布局样式配置，用于多产品差异化配置
   *
   * @param cardType 大卡类型
   * @param style 样式配置
   */
  public setCardItemStyle(cardType: CardShowType, style: WidgetStyleStateV2): void {
    if (!style) {
      return;
    }
    let itemConfig = this.cardItemStyle.get(cardType);
    if (itemConfig) {
      itemConfig.bindBpConfig(style.getBpSplice(), style);
    } else {
      this.cardItemStyle.set(cardType, StyleStateConfig.wrap(cardType).bindBpConfig(style.getBpSplice(), style));
    }
  }

  /**
   * 赋值沉浸大卡通用布局样式配置，用于多产品差异化配置
   *
   * @param cardSf 大卡样式后缀
   * @param style 样式配置
   */
  public setCardComViewStyle(cardSf: CardStyleSuffix, style: WidgetStyleStateV2): void {
    if (!style) {
      return;
    }
    let config = this.cardComViewStyle.get(cardSf);
    if (config) {
      config.bindBpConfig(style.getBpSplice(), style);
    } else {
      this.cardComViewStyle.set(cardSf, StyleStateConfig.wrap(cardSf).bindBpConfig(style.getBpSplice(), style));
    }
  }

  /**
   * 取值沉浸大卡默认配置
   *
   * @param bpSplice 屏幕断点拼接
   * @returns 大卡配置
   */
  public getCardConfig(bpSplice: SizeBpSplice = SizeBpSplice.DEFAULT): SlCardConfigStateV2 {
    let config = this.cardConfig.getBpConfig(bpSplice);
    if (config) {
      return config;
    }
    return this.cardConfig.getConfig() ?? CARD_DEFAULT_CONFIG;
  }

  /**
   * 取值沉浸大卡root样式配置
   *
   * @param bpSplice 屏幕断点拼接
   * @returns 样式配置
   */
  public getCardRootStyle(bpSplice: SizeBpSplice = SizeBpSplice.DEFAULT): WidgetStyleStateV2 {
    let style = this.cardRootStyle.getBpConfig(bpSplice);
    if (style) {
      return style;
    }
    return this.cardRootStyle.getConfig() ?? CARD_DEFAULT_STYLE;
  }

  /**
   * 取值沉浸大卡条目样式配置
   *
   * @param cardType 大卡类型
   * @param bpSplice 屏幕断点拼接
   * @returns 样式配置
   */
  public getCardItemStyle(cardType: CardShowType, bpSplice: SizeBpSplice = SizeBpSplice.DEFAULT): WidgetStyleStateV2 {
    let config = this.cardItemStyle.get(cardType);
    return (config?.getBpConfig(bpSplice) ?? config?.getConfig()) ?? CARD_DEFAULT_ITEM_STYLE;
  }

  /**
   * 取值沉浸大卡通用布局样式配置
   *
   * @param cardSf 通用布局样式后缀
   * @param bpSplice 屏幕断点拼接
   * @returns 样式配置
   */
  public getCardComViewStyle(cardSf: CardStyleSuffix, bpSplice?: SizeBpSplice): WidgetStyleStateV2 | undefined {
    let bpResult = bpSplice ?? SizeBpSplice.DEFAULT;
    let config = this.cardComViewStyle.get(cardSf);
    return config?.getBpConfig(bpResult) ?? config?.getConfig();
  }
}