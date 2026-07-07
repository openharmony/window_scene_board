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
  SlCapStaticStPt,
  SlStateId,
  StateModeId,
} from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { StyleStateConfig, WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { BrightnessOptionUtils, LiveStyle } from '@ohos/systemuicommon/Index';
import { CapShowType, CapStyleSuffix } from '../../common/constants/ImmCapConst';
import { ICapStyleConfigHelper } from '../../common/interface/ICapStyleConfigHelper';
import { SlCapConfigStateV2 } from '../data/v2/SlCapConfigStateV2';
import { SlCapStateConfig } from '../data/v2/SlCapStateConfig';

// 胶囊默认扩展配置
const CAP_DEFAULT_CONFIG = BaseState.wrap<SlCapConfigStateV2>(SlCapConfigStateV2, SizeBpSplice.DEFAULT)
  .setShowBtnCount(1);

// 胶囊直板机横向扩展配置
const CAP_MS_CONFIG = BaseState.wrap<SlCapConfigStateV2>(SlCapConfigStateV2, SizeBpSplice.MS)
  .setUseHeightCal(true)
  .setShowBtnCount(1);

// 胶囊PAD扩展配置
const CAP_ML_LS_CONFIG = BaseState.wrap<SlCapConfigStateV2>(SlCapConfigStateV2, SizeBpSplice.ML)
  .setShowBtnCount(3);

// 胶囊默认样式
const CAP_DEFAULT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setBorderRadius(24)
  .setHeight(54) // 胶囊根布局固定高度
  .setMarginL(76).setMarginR(76); // 直板机样式，默认样式，左右两侧固定间距

// 胶囊中等宽度样式
const CAP_M_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.MM)
  .setBorderRadius(24)
  .setHeight(54) // 胶囊根布局固定高度
  .setMarginL(1 / 3).setMarginR(1 / 3); // 大折叠展开态，PAD竖屏，左右两侧间距占屏幕宽度各1/3

// 胶囊大宽度样式
const CAP_L_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.LS)
  .setBorderRadius(24)
  .setHeight(54) // 胶囊根布局固定高度
  .setMarginL(3 / 8).setMarginR(3 / 8); // PAD横屏，左右两侧间距占屏幕宽度各3/8

// 主胶囊默认(浅色)背景样式
const MAIN_CAP_DEF = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DEFAULT)
  .setBgColor('#ff000000') // 默认背景颜色保持黑色
  .setBgBrightnessInner(BrightnessOptionUtils.keyguardCapsuleBackFirstLightOption);

// 主胶囊深色背景样式
const MAIN_CAP_DARK = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .setBgBrightnessInner(BrightnessOptionUtils.keyguardCapsuleBackFirstDarkOption);

// 主胶囊AOD样式
const MAIN_CAP_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setBgColor('#ff2d2d2d') // AOD背景颜色
  .setBgBrightnessInner(BrightnessOptionUtils.aodScreenNtfBaseboardLightOption);

// 阴影胶囊默认(浅色)背景样式
const SHADOW_CAP_DEF = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DEFAULT)
  .setBgColor('#ff000000') // 默认背景颜色保持黑色
  .setBgBrightnessInner(BrightnessOptionUtils.keyguardCapsuleBackSecondLightOption);

// 阴影胶囊浅色背景样式
const SHADOW_CAP_LIGHT = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.LIGHT)
  .setBgBrightnessInner(BrightnessOptionUtils.keyguardCapsuleBackSecondLightOption);

// 阴影胶囊深色背景样式
const SHADOW_CAP_DARK = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .setBgBrightnessInner(BrightnessOptionUtils.keyguardCapsuleBackSecondDarkOption);

// 阴影胶囊AOD样式
const SHADOW_CAP_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setBgColor('#ff242424')
  .setBgBrightnessInner(BrightnessOptionUtils.aodScreenNtfSecondBoardLightOption);

// 主胶囊纯色下深色背景样式
const MAIN_CAP_SOLID_DARK = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 主胶囊纯色下浅色背景样式
const MAIN_CAP_SOLID_LIGHT = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.LIGHT)
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 主胶囊纯色下AOD样式
const MAIN_CAP_SOLID_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setBgColor('#ff2d2d2d') // AOD保持独立颜色
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 主胶囊禁用提亮下深色背景样式
const MAIN_CAP_BRIGHT_DARK = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .setUseEffect(false)
  .setBgColor('#2fffffff')
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 主胶囊禁用提亮下浅色背景样式
const MAIN_CAP_BRIGHT_LIGHT = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.LIGHT)
  .setUseEffect(false)
  .setBgColor('#3a303030')
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 主胶囊禁用提亮下AOD样式
const MAIN_CAP_BRIGHT_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setUseEffect(false)
  .setBgColor('#ff2d2d2d')
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 阴影胶囊纯色下深色背景样式
const SHADOW_CAP_SOLID_DARK = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 阴影胶囊纯色下浅色背景样式
const SHADOW_CAP_SOLID_LIGHT = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.LIGHT)
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 阴影胶囊纯色下AOD样式
const SHADOW_CAP_SOLID_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setBgColor('#ff242424') // AOD保持独立颜色
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 阴影胶囊禁用提亮下深色背景样式
const SHADOW_CAP_BRIGHT_DARK = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .setUseEffect(false)
  .setBgColor('#37a8a8a8')
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 阴影胶囊禁用提亮下浅色背景样式
const SHADOW_CAP_BRIGHT_LIGHT = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.LIGHT)
  .setUseEffect(false)
  .setBgColor('#40101010')
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 阴影胶囊禁用提亮下AOD样式
const SHADOW_CAP_BRIGHT_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setUseEffect(false)
  .setBgColor('#ff242424')
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 胶囊强提醒样式
const CAP_REMIND_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setHeight(48).setPaddingL(6).setPaddingR(6).setBorderRadiusTL(24) // 强提醒胶囊固定高度、内间距
  .setVisibility(Visibility.Hidden) // 强提醒胶囊默认不可见
  .setEnable(false) // 强提醒胶囊默认不可交互
  .setZIndex(-1) // 强提醒胶囊默认底部不可见
  .setAccessibilityLevel('yes') // 无障碍等级
  .setPointLight({ illuminated: IlluminatedType.BORDER }) // 光影投射
  .addChildState(MAIN_CAP_DEF) // 默认浅色背景下样式
  .addChildState(MAIN_CAP_DARK) // 深色背景下样式
  .addChildState(MAIN_CAP_AOD) // AOD下样式
  .addChildState( // 纯色模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.SOLID)
      .setConfigId(SlCapStaticStPt.PT_MAIN_CAP_SOLID_BG_COLOR) // 配置标识-主胶囊纯色
      .addChildState(MAIN_CAP_SOLID_DARK) // 纯色模式嵌套深色背景下样式
      .addChildState(MAIN_CAP_SOLID_LIGHT) // 纯色模式嵌套浅色背景下样式
      .addChildState(MAIN_CAP_SOLID_AOD) // 纯色模式嵌套AOD下样式
  )
  .addChildState( // 禁用提亮模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DIS_BRIGHT)
      .addChildState(MAIN_CAP_BRIGHT_DARK) // 禁用提亮嵌套深色背景下样式
      .addChildState(MAIN_CAP_BRIGHT_LIGHT) // 禁用提亮嵌套浅色背景下样式
      .addChildState(MAIN_CAP_BRIGHT_AOD) // 禁用提亮嵌套AOD下样式
  )
  .addChildState( // 强提醒下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.REMIND)
      .setVisibility(Visibility.Visible) // 强提醒时保持可见
      .setEnable(true) // 强提醒时可交互
      .setZIndex(2) // 强提醒时保持顶部可见
  );

// 胶囊默认条目样式
const CAP_DEF_ITEM_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setHeight(48).setPaddingL(6).setPaddingR(6).setBorderRadiusTL(24) // 胶囊固定高度、内间距
  .setVisibility(Visibility.Hidden) // 胶囊默认不可见
  .setEnable(false) // 胶囊不可交互
  .setAccessibilityLevel('yes') // 无障碍等级
  .setPointLight({ illuminated: IlluminatedType.BORDER }) // 光影投射
  .addChildState(MAIN_CAP_DEF) // 默认浅色背景下样式
  .addChildState(MAIN_CAP_DARK) // 深色背景下样式
  .addChildState(MAIN_CAP_AOD) // AOD下样式
  .addChildState( // 纯色模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.SOLID)
      .setConfigId(SlCapStaticStPt.PT_MAIN_CAP_SOLID_BG_COLOR) // 配置标识-主胶囊纯色
      .addChildState(MAIN_CAP_SOLID_DARK) // 纯色模式嵌套深色背景下样式
      .addChildState(MAIN_CAP_SOLID_LIGHT) // 纯色模式嵌套浅色背景下样式
      .addChildState(MAIN_CAP_SOLID_AOD) // 纯色模式嵌套AOD下样式
  )
  .addChildState( // 禁用提亮模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DIS_BRIGHT)
      .addChildState(MAIN_CAP_BRIGHT_DARK) // 禁用提亮嵌套深色背景下样式
      .addChildState(MAIN_CAP_BRIGHT_LIGHT) // 禁用提亮嵌套浅色背景下样式
      .addChildState(MAIN_CAP_BRIGHT_AOD) // 禁用提亮嵌套AOD下样式
  );

// 胶囊内容样式
const CAP_CONTENT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setHeight(48).setPaddingL(6).setPaddingR(6).setBorderRadiusTL(24) // 内容胶囊固定高度、内间距
  .setVisibility(Visibility.Visible) // 内容胶囊默认可见
  .setEnable(true) // 内容胶囊可交互
  .setAccessibilityLevel('yes') // 无障碍等级
  .setPointLight({ illuminated: IlluminatedType.BORDER }) // 光影投射
  .addChildState(MAIN_CAP_DEF) // 默认浅色背景下样式
  .addChildState(MAIN_CAP_DARK) // 深色背景下样式
  .addChildState(MAIN_CAP_AOD) // AOD下样式
  .addChildState( // 纯色模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.SOLID)
      .setConfigId(SlCapStaticStPt.PT_MAIN_CAP_SOLID_BG_COLOR) // 配置标识-主胶囊纯色
      .addChildState(MAIN_CAP_SOLID_DARK) // 纯色模式嵌套深色背景下样式
      .addChildState(MAIN_CAP_SOLID_LIGHT) // 纯色模式嵌套浅色背景下样式
      .addChildState(MAIN_CAP_SOLID_AOD) // 纯色模式嵌套AOD下样式
  )
  .addChildState( // 禁用提亮模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DIS_BRIGHT)
      .addChildState(MAIN_CAP_BRIGHT_DARK) // 禁用提亮嵌套深色背景下样式
      .addChildState(MAIN_CAP_BRIGHT_LIGHT) // 禁用提亮嵌套浅色背景下样式
      .addChildState(MAIN_CAP_BRIGHT_AOD) // 禁用提亮嵌套AOD下样式
  )
  .addChildState( // 强提醒下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.REMIND)
      .setEnable(false) // 强提醒下不可交互
      .setMarginT(6).setMarginL(6).setMarginR(6) // 强提醒下间距和阴影胶囊保持一致
      .addChildState(SHADOW_CAP_DARK) // 强提醒嵌套深色背景下样式，与阴影胶囊保持一致
      .addChildState(SHADOW_CAP_LIGHT) // 强提醒嵌套浅色背景下样式，与阴影胶囊保持一致
  );

// 胶囊阴影样式
const CAP_SHADOW_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setHeight(48).setPaddingL(6).setPaddingR(6).setBorderRadiusTL(24) // 阴影胶囊固定高度、内间距
  .setMarginT(6).setMarginL(6).setMarginR(6) // 阴影胶囊固定间距
  .setVisibility(Visibility.Visible) // 阴影胶囊默认可见
  .setEnable(false) // 阴影胶囊不可交互
  .setAccessibilityLevel('no-hide-descendants') // 无障碍等级
  .setPointLight({ illuminated: IlluminatedType.BORDER }) // 光影投射
  .addChildState(SHADOW_CAP_DEF) // 默认浅色背景下样式
  .addChildState(SHADOW_CAP_DARK) // 深色背景下样式
  .addChildState(SHADOW_CAP_AOD) // AOD下样式
  .addChildState( // 纯色模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.SOLID)
      .setConfigId(SlCapStaticStPt.PT_SHADOW_CAP_SOLID_BG_COLOR) // 配置标识-主胶囊纯色
      .addChildState(SHADOW_CAP_SOLID_DARK) // 纯色模式嵌套深色背景下样式
      .addChildState(SHADOW_CAP_SOLID_LIGHT) // 纯色模式嵌套浅色背景下样式
      .addChildState(SHADOW_CAP_SOLID_AOD) // 纯色模式嵌套AOD下样式
  )
  .addChildState( // 禁用提亮模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DIS_BRIGHT)
      .addChildState(SHADOW_CAP_BRIGHT_DARK) // 禁用提亮嵌套深色背景下样式
      .addChildState(SHADOW_CAP_BRIGHT_LIGHT) // 禁用提亮嵌套浅色背景下样式
      .addChildState(SHADOW_CAP_BRIGHT_AOD) // 禁用提亮嵌套AOD下样式
  )
  .addChildState( // 强提醒下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.REMIND)
      .setVisibility(Visibility.None) // 强提醒时隐藏
  );

// 胶囊通用布局大图标样式
const CAP_LARGE_ICON_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setWidth(36).setHeight(36).setBorderRadiusTL(18).setMarginT(6).setMarginB(6)
  .addChildState( // 默认样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DEFAULT)
      .setColorFilter(LiveStyle.BLACK_COLOR_FILTER)
  )
  .addChildState( // 深色壁纸下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
      .setColorFilter(LiveStyle.WHITE_COLOR_FILTER)
  )
  .addChildState( // AOD样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setColorFilter(LiveStyle.WHITE_COLOR_FILTER)
      .setAlpha(0.4)
  );

// 胶囊通用布局小图标样式
const CAP_SM_ICON_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setWidth(14).setHeight(14).setBorderRadiusTL(4).setBorderRadiusTR(4)
  .setBorderRadiusBL(4).setBorderRadiusBR(4).setOffset({ x: 2, y: 2 })
  .addChildState( // AOD样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setAlpha(0.4)
  );

// 胶囊通用布局小图标背景样式
const CAP_SM_ICON_BG_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setWidth(14).setHeight(14).setBorderRadiusTL(4).setBorderRadiusTR(4)
  .setBorderRadiusBL(4).setBorderRadiusBR(4).setOffset({ x: 2, y: 2 })
  .addChildState( // 默认样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DEFAULT)
      .setVisibility(Visibility.None)
  )
  .addChildState( // AOD样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setVisibility(Visibility.Visible).setBgColor('#FF2D2D2D')
  );

// 胶囊通用布局小图标克隆应用样式
const CAP_SMALL_ICON_REVERSE_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setWidth(5.73).setHeight(5.33).setOffset({ x: -7.13, y: -6 })
  .addChildState( // 默认样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DEFAULT)
      .setFillColor('#FFFFFFFF')
  )
  .addChildState( // AOD样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setFillColor('#40FFFFFF')
  );

// 胶囊通用布局小图标背景克隆应用样式
const CAP_SMALL_ICON_BG_REVERSE_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setWidth(13.33).setHeight(10.67).setBorderRadiusTL(32 / 3).setBorderRadiusTR(2 / 3)
  .setBorderRadiusBL(2 / 3).setBorderRadiusBR(32 / 3).setOffset({ x: -3.33, y: -3.33 })
  .addChildState( // 默认样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DEFAULT)
      .setVisibility(Visibility.Visible).setBgColor('#000000').setAlpha(0.3)
  )
  .addChildState( // AOD样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setVisibility(Visibility.Visible).setBgColor('#000000').setAlpha(0.4)
  );

// 主文本默认浅色背景下样式
const MAIN_TEXT_DEF = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DEFAULT)
  .setFontColor('#000000').setFgBrightness(BrightnessOptionUtils.getInstance().foregroundPrimaryOptionLight);

// 主文本深色背景下样式
const MAIN_TEXT_DARK = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .setFontColor('#ffffff').setFgBrightness(BrightnessOptionUtils.getInstance().foregroundPrimaryOptionDark);

// 主文本AOD下样式
const MAIN_TEXT_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setFontColor('#66ffffff').setFgBrightness(BrightnessOptionUtils.aodTimeLightOptionForFillColor);

// 主文本纯色模式嵌套浅色背景下样式
const MAIN_TEXT_SOLID_LIGHT = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.LIGHT)
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS);

// 主文本纯色模式嵌套深色背景下样式
const MAIN_TEXT_SOLID_DARK = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS);

// 主文本纯色模式嵌套AOD下样式
const MAIN_TEXT_SOLID_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setFontColor('#66ffffff')
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS);

// 主文本禁用提亮模式嵌套浅色背景下样式
const MAIN_TEXT_BRIGHT_LIGHT = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.LIGHT)
  .setFontColor('#c5000000')
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS);

// 主文本禁用提亮模式嵌套深色背景下样式
const MAIN_TEXT_BRIGHT_DARK = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .setFontColor('#f8ffffff')
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS);

// 主文本禁用提亮模式嵌套AOD下样式
const MAIN_TEXT_BRIGHT_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setFontColor('#66ffffff')
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS);

// 胶囊通用布局主文本样式
const CAP_MAIN_TEXT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setFontSize(14).setMinFontSize(12).setMinFontScale(0.5).setMaxFontScale(1.15).setHeight(19)
  .setMarginL(6).setMarginR(10) // 共用默认属性
  .addChildState(MAIN_TEXT_DEF)
  .addChildState(MAIN_TEXT_DARK)
  .addChildState(MAIN_TEXT_AOD)
  .addChildState( // 纯色模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.SOLID)
      .setConfigId(SlCapStaticStPt.PT_MAIN_CAP_SOLID_FG_COLOR) // 配置标识-主文本纯色
      .addChildState(MAIN_TEXT_SOLID_LIGHT)
      .addChildState(MAIN_TEXT_SOLID_DARK)
      .addChildState(MAIN_TEXT_SOLID_AOD)
  )
  .addChildState( // 禁用提亮模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DIS_BRIGHT)
      .addChildState(MAIN_TEXT_BRIGHT_LIGHT)
      .addChildState(MAIN_TEXT_BRIGHT_DARK)
      .addChildState(MAIN_TEXT_BRIGHT_AOD)
  );

// 副文本默认浅色背景下样式
const SECONDARY_TEXT_DEF = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DEFAULT)
  .setFontColor('#cc000000').setFgBrightness(BrightnessOptionUtils.getInstance().foregroundSecondaryOption);

// 副文本深色背景下样式
const SECONDARY_TEXT_DARK = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .setFontColor('#ccffffff').setFgBrightness(BrightnessOptionUtils.getInstance().foregroundSecondaryDarkOption);

// 副文本AOD下样式
const SECONDARY_TEXT_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setFontColor('#66ffffff').setFgBrightness(BrightnessOptionUtils.aodTimeLightOptionForFillColor);

// 副文本纯色模式嵌套浅色背景下样式
const SECONDARY_TEXT_SOLID_LIGHT = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.LIGHT)
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS);

// 副文本纯色模式嵌套深色背景下样式
const SECONDARY_TEXT_SOLID_DARK = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS);

// 副文本纯色模式嵌套AOD下样式
const SECONDARY_TEXT_SOLID_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setFontColor('#66ffffff')
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS);

// 副文本禁用提亮模式嵌套浅色背景下样式
const SECONDARY_TEXT_BRIGHT_LIGHT = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.LIGHT)
  .setFontColor('#ae000000')
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS);

// 副文本禁用提亮模式嵌套深色背景下样式
const SECONDARY_TEXT_BRIGHT_DARK = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .setFontColor('#c2ffffff')
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS);

// 副文本禁用提亮模式嵌套AOD下样式
const SECONDARY_TEXT_BRIGHT_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setFontColor('#66ffffff')
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS);

// 胶囊通用布局副文本样式
const CAP_SECONDARY_TEXT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setFontSize(12).setMinFontScale(0.5).setMaxFontScale(1.15).setHeight(17)
  .setMarginL(6).setMarginR(10) // 共用默认属性
  .addChildState(SECONDARY_TEXT_DEF)
  .addChildState(SECONDARY_TEXT_DARK)
  .addChildState(SECONDARY_TEXT_AOD)
  .addChildState( // 纯色模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.SOLID)
      .setConfigId(SlCapStaticStPt.PT_SHADOW_CAP_SOLID_FG_COLOR) // 配置标识-副文本纯色
      .addChildState(SECONDARY_TEXT_SOLID_LIGHT)
      .addChildState(SECONDARY_TEXT_SOLID_DARK)
      .addChildState(SECONDARY_TEXT_SOLID_AOD)
  )
  .addChildState( // 禁用提亮模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DIS_BRIGHT)
      .addChildState(SECONDARY_TEXT_BRIGHT_LIGHT)
      .addChildState(SECONDARY_TEXT_BRIGHT_DARK)
      .addChildState(SECONDARY_TEXT_BRIGHT_AOD)
  );

// 胶囊通用布局扩展区样式
const CAP_EXTENSION_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setItemSpace(8).setWidth(36).setHeight(36).setMarginL(6).setMarginT(6).setMarginB(6)
  .addChildState( // 默认样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DEFAULT)
      .setAlpha(1)
  )
  .addChildState( // AOD下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setAlpha(0.4)
  );

// 扩展区文本默认浅色背景下样式
const EXT_TEXT_DEF = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DEFAULT)
  .setFontColor('#000000').setFgBrightness(BrightnessOptionUtils.getInstance().foregroundPrimaryOptionLight);

// 扩展区文本深色背景下样式
const EXT_TEXT_DARK = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .setFontColor('#ffffff').setFgBrightness(BrightnessOptionUtils.getInstance().foregroundPrimaryOptionDark);

// 扩展区文本AOD下样式
const EXT_TEXT_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setFontColor('#66ffffff').setFgBrightness(BrightnessOptionUtils.aodTimeLightOptionForFillColor);

// 扩展区文本纯色模式嵌套浅色背景下样式
const EXT_TEXT_SOLID_LIGHT = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.LIGHT)
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS);

// 扩展区文本纯色模式嵌套深色背景下样式
const EXT_TEXT_SOLID_DARK = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS);

// 扩展区文本纯色模式嵌套AOD下样式
const EXT_TEXT_SOLID_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setFontColor('#66ffffff')
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS);

// 扩展区文本禁用提亮模式嵌套浅色背景下样式
const EXT_TEXT_BRIGHT_LIGHT = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.LIGHT)
  .setFontColor('#c5000000')
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS);

// 扩展区文本禁用提亮模式嵌套深色背景下样式
const EXT_TEXT_BRIGHT_DARK = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .setFontColor('#f8ffffff')
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS);

// 扩展区文本禁用提亮模式嵌套AOD下样式
const EXT_TEXT_BRIGHT_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setFontColor('#66ffffff')
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS);

// 胶囊通用布局扩展区中文本样式
const CAP_EXT_TEXT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setWidth(36).setHeight(36).setMaxFontSize('14vp').setMinFontSize('10vp')
  .addChildState(EXT_TEXT_DEF)
  .addChildState(EXT_TEXT_DARK)
  .addChildState(EXT_TEXT_AOD)
  .addChildState( // 纯色模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.SOLID)
      .setConfigId(SlCapStaticStPt.PT_EXT_TEXT_SOLID_FG_COLOR) // 配置标识-扩展区文本纯色
      .addChildState(EXT_TEXT_SOLID_LIGHT)
      .addChildState(EXT_TEXT_SOLID_DARK)
      .addChildState(EXT_TEXT_SOLID_AOD)
  )
  .addChildState( // 禁用提亮模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DIS_BRIGHT)
      .addChildState(EXT_TEXT_BRIGHT_LIGHT)
      .addChildState(EXT_TEXT_BRIGHT_DARK)
      .addChildState(EXT_TEXT_BRIGHT_AOD)
  );

// 扩展区按钮默认浅色背景下样式
const EXT_BTN_DEF = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DEFAULT)
  .setBgColor('#000000').setBgBrightnessInner(BrightnessOptionUtils.immersiveCapBgcDarkOption);

// 扩展区按钮深色背景下样式
const EXT_BTN_DARK = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .setBgColor('#ffffff').setBgBrightnessInner(BrightnessOptionUtils.immersiveCapBgcLightOption);

// 扩展区按钮AOD下样式
const EXT_BTN_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setBgColor('#66ffffff').setBgBrightnessInner(BrightnessOptionUtils.getInstance().aodTimeLightOptionForButtonBgColor)
  .setAlpha(0.3);

// 扩展区按钮纯色模式嵌套浅色背景下样式
const EXT_BTN_SOLID_LIGHT = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.LIGHT)
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 扩展区按钮纯色模式嵌套深色背景下样式
const EXT_BTN_SOLID_DARK = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 扩展区按钮纯色模式嵌套AOD下样式
const EXT_BTN_SOLID_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setBgColor('#66ffffff')
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 扩展区按钮禁用提亮模式嵌套浅色背景下样式
const EXT_BTN_BRIGHT_LIGHT = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.LIGHT)
  .setBgColor('#27000000')
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 扩展区按钮禁用提亮模式嵌套深色背景下样式
const EXT_BTN_BRIGHT_DARK = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .setBgColor('#24ffffff')
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 扩展区按钮禁用提亮模式嵌套AOD下样式
const EXT_BTN_BRIGHT_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setBgColor('#66ffffff')
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 胶囊通用布局扩展区中按钮样式
const CAP_EXT_BTN_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setHeight(10).setBgWidth(56).setBgHeight(20).setMarginT(2).setMarginL(2)
  .addChildState(EXT_BTN_DEF)
  .addChildState(EXT_BTN_DARK)
  .addChildState(EXT_BTN_AOD)
  .addChildState( // 纯色模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.SOLID)
      .setConfigId(SlCapStaticStPt.PT_EXT_BTN_SOLID_BG_COLOR) // 配置标识-扩展区按钮纯色
      .addChildState(EXT_BTN_SOLID_LIGHT)
      .addChildState(EXT_BTN_SOLID_DARK)
      .addChildState(EXT_BTN_SOLID_AOD)
  )
  .addChildState( // 禁用提亮模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DIS_BRIGHT)
      .addChildState(EXT_BTN_BRIGHT_LIGHT)
      .addChildState(EXT_BTN_BRIGHT_DARK)
      .addChildState(EXT_BTN_BRIGHT_AOD)
  );

// 胶囊系统按钮默认浅色背景下样式
const CAP_BTN_DEF = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DEFAULT)
  .setBgColor('#FF000000').setBgBrightnessInner(BrightnessOptionUtils.CAPSULE_EXTEND_DARK_OPTION);

// 胶囊系统按钮深色背景下样式
const CAP_BTN_DARK = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .setBgColor('#FF000000').setBgBrightnessInner(BrightnessOptionUtils.CAPSULE_EXTEND_LIGHT_OPTION);

// 胶囊系统按钮AOD下样式
const CAP_BTN_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setBgColor('#FF000000').setBgBrightnessInner(BrightnessOptionUtils.CAPSULE_EXTEND_DARK_OPTION)
  .setAlpha(0.1);

// 胶囊系统按钮纯色模式嵌套浅色背景下样式
const CAP_BTN_SOLID_LIGHT = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.LIGHT)
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 胶囊系统按钮纯色模式嵌套深色背景下样式
const CAP_BTN_SOLID_DARK = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 胶囊系统按钮纯色模式嵌套AOD下样式
const CAP_BTN_SOLID_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setBgColor('#FF000000')
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 胶囊系统按钮禁用提亮模式嵌套浅色背景下样式
const CAP_BTN_BRIGHT_LIGHT = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.LIGHT)
  .setBgColor('#27000000')
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 胶囊系统按钮禁用提亮模式嵌套深色背景下样式
const CAP_BTN_BRIGHT_DARK = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
  .setBgColor('#24ffffff')
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 胶囊系统按钮禁用提亮模式嵌套AOD下样式
const CAP_BTN_BRIGHT_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setBgColor('#FF000000')
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 胶囊通用布局系统按钮样式
const CAP_BTN_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setWidth(36).setHeight(36)
  .addChildState(CAP_BTN_DEF)
  .addChildState(CAP_BTN_DARK)
  .addChildState(CAP_BTN_AOD)
  .addChildState( // 纯色模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.SOLID)
      .setConfigId(SlCapStaticStPt.PT_BTN_SOLID_BG_COLOR) // 配置标识-系统按钮纯色
      .addChildState(CAP_BTN_SOLID_LIGHT)
      .addChildState(CAP_BTN_SOLID_DARK)
      .addChildState(CAP_BTN_SOLID_AOD)
  )
  .addChildState( // 禁用提亮模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DIS_BRIGHT)
      .addChildState(CAP_BTN_BRIGHT_LIGHT)
      .addChildState(CAP_BTN_BRIGHT_DARK)
      .addChildState(CAP_BTN_BRIGHT_AOD)
  );

/**
 * 沉浸胶囊样式默认配置辅助工具
 */
export class CapStyleConfigH implements ICapStyleConfigHelper {
  // 胶囊扩展配置
  private readonly capConfig: SlCapStateConfig = SlCapStateConfig.wrap(SlStateId.SL_CAP_STATE)
    .bindBpConfig(SizeBpSplice.DEFAULT, CAP_DEFAULT_CONFIG)
    .bindBpConfig(SizeBpSplice.MS, CAP_MS_CONFIG)
    .bindBpConfig(SizeBpSplice.ML, CAP_ML_LS_CONFIG)
    .bindBpConfig(SizeBpSplice.LL, CAP_ML_LS_CONFIG)
    .bindBpConfig(SizeBpSplice.LS, CAP_ML_LS_CONFIG)
    .bindBpConfig(SizeBpSplice.XS, CAP_ML_LS_CONFIG);

  // 胶囊样式配置
  private readonly capRootStyle: StyleStateConfig = StyleStateConfig.wrap(SlStateId.SL_CAP_STATE)
    .bindBpConfig(SizeBpSplice.DEFAULT, CAP_DEFAULT_STYLE)
    .bindBpConfig(SizeBpSplice.MM, CAP_M_STYLE)
    .bindBpConfig(SizeBpSplice.ML, CAP_M_STYLE)
    .bindBpConfig(SizeBpSplice.LL, CAP_M_STYLE)
    .bindBpConfig(SizeBpSplice.LS, CAP_L_STYLE)
    .bindBpConfig(SizeBpSplice.XS, CAP_L_STYLE);

  // 胶囊条目样式配置
  private readonly capItemStyle: Map<CapShowType, StyleStateConfig> = new Map([
    [CapShowType.CAP_SHADOW, StyleStateConfig.wrap(CapShowType.CAP_SHADOW).bindConfig(CAP_SHADOW_STYLE)],
    [CapShowType.CAP_CONTENT, StyleStateConfig.wrap(CapShowType.CAP_CONTENT).bindConfig(CAP_CONTENT_STYLE)],
    [CapShowType.CAP_REMIND, StyleStateConfig.wrap(CapShowType.CAP_REMIND).bindConfig(CAP_REMIND_STYLE)],
    [CapShowType.CAP_CARD, StyleStateConfig.wrap(CapShowType.CAP_CARD).bindConfig(CAP_DEF_ITEM_STYLE)],
    [CapShowType.CAP_CARD_BACK, StyleStateConfig.wrap(CapShowType.CAP_CARD_BACK).bindConfig(CAP_DEF_ITEM_STYLE)],
    [CapShowType.CAP_REMOVE, StyleStateConfig.wrap(CapShowType.CAP_REMOVE).bindConfig(CAP_DEF_ITEM_STYLE)],
    [CapShowType.CAP_ADD, StyleStateConfig.wrap(CapShowType.CAP_ADD).bindConfig(CAP_DEF_ITEM_STYLE)],
    [CapShowType.CAP_UPDATE, StyleStateConfig.wrap(CapShowType.CAP_UPDATE).bindConfig(CAP_DEF_ITEM_STYLE)],
  ]);

  // 胶囊通用布局样式配置
  private readonly capComViewStyle: Map<CapStyleSuffix, StyleStateConfig> = new Map([
    [ // 大图标样式
      CapStyleSuffix.ITEM_LARGE_ICON_STYLE,
      StyleStateConfig.wrap(CapStyleSuffix.ITEM_LARGE_ICON_STYLE).bindConfig(CAP_LARGE_ICON_STYLE)
    ],
    [ // 小图标样式
      CapStyleSuffix.ITEM_SMALL_ICON_STYLE,
      StyleStateConfig.wrap(CapStyleSuffix.ITEM_SMALL_ICON_STYLE).bindConfig(CAP_SM_ICON_STYLE)
    ],
    [ // 小图标背景样式
      CapStyleSuffix.ITEM_SMALL_ICON_BG_STYLE,
      StyleStateConfig.wrap(CapStyleSuffix.ITEM_SMALL_ICON_BG_STYLE).bindConfig(CAP_SM_ICON_BG_STYLE)
    ],
    [ // 小图标克隆应用样式
      CapStyleSuffix.ITEM_SMALL_ICON_REVERSE_STYLE,
      StyleStateConfig.wrap(CapStyleSuffix.ITEM_SMALL_ICON_REVERSE_STYLE).bindConfig(CAP_SMALL_ICON_REVERSE_STYLE)
    ],
    [ // 小图标背景克隆应用样式
      CapStyleSuffix.ITEM_SMALL_ICON_BG_REVERSE_STYLE,
      StyleStateConfig.wrap(CapStyleSuffix.ITEM_SMALL_ICON_BG_REVERSE_STYLE).bindConfig(CAP_SMALL_ICON_BG_REVERSE_STYLE)
    ],
    [ // 主文本样式
      CapStyleSuffix.ITEM_MAIN_TEXT_STYLE,
      StyleStateConfig.wrap(CapStyleSuffix.ITEM_MAIN_TEXT_STYLE).bindConfig(CAP_MAIN_TEXT_STYLE)
    ],
    [ // 副文本样式
      CapStyleSuffix.ITEM_SECONDARY_TEXT_STYLE,
      StyleStateConfig.wrap(CapStyleSuffix.ITEM_SECONDARY_TEXT_STYLE).bindConfig(CAP_SECONDARY_TEXT_STYLE)
    ],
    [ // 扩展区样式
      CapStyleSuffix.ITEM_EXTENSION_STYLE,
      StyleStateConfig.wrap(CapStyleSuffix.ITEM_EXTENSION_STYLE).bindConfig(CAP_EXTENSION_STYLE)
    ],
    [ // 扩展区文本样式
      CapStyleSuffix.ITEM_EXT_TEXT_STYLE,
      StyleStateConfig.wrap(CapStyleSuffix.ITEM_EXT_TEXT_STYLE).bindConfig(CAP_EXT_TEXT_STYLE)
    ],
    [ // 扩展区按钮样式
      CapStyleSuffix.ITEM_EXT_BTN_STYLE,
      StyleStateConfig.wrap(CapStyleSuffix.ITEM_EXT_BTN_STYLE).bindConfig(CAP_EXT_BTN_STYLE)
    ],
    [ // 系统按钮样式
      CapStyleSuffix.ITEM_BUTTON_STYLE,
      StyleStateConfig.wrap(CapStyleSuffix.ITEM_BUTTON_STYLE).bindConfig(CAP_BTN_STYLE)
    ]
  ]);

  /**
   * 清空胶囊所有配置
   */
  public clearCapConfig(): void {
    this.capConfig.clearConfig();
    this.capRootStyle.clearConfig();
    this.capItemStyle.clear();
    this.capComViewStyle.clear();
  }

  /**
   * 设置胶囊样式配置，用于产品差异化配置
   *
   * @param style 样式配置
   */
  public setCapRootStyle(style: WidgetStyleStateV2): void {
    if (style) {
      this.capRootStyle.bindBpConfig(style.getBpSplice(), style);
    }
  }

  /**
   * 设置胶囊配置，用于产品差异化配置
   *
   * @param config 配置
   */
  public setCapConfig(config: SlCapConfigStateV2): void {
    if (config) {
      this.capConfig.bindBpConfig(config.getBpSplice(), config);
    }
  }

  /**
   * 设置胶囊条目样式配置，用于多产品差异化配置
   *
   * @param capType 胶囊item类型
   * @param style 样式配置
   */
  public setCapItemStyle(capType: CapShowType, style: WidgetStyleStateV2): void {
    if (!style) {
      return;
    }
    let itemConfig = this.capItemStyle.get(capType);
    if (itemConfig) {
      itemConfig.bindBpConfig(style.getBpSplice(), style);
    } else {
      this.capItemStyle.set(capType, StyleStateConfig.wrap(capType).bindBpConfig(style.getBpSplice(), style));
    }
  }

  /**
   * 设置胶囊通用布局样式配置，用于多产品差异化配置
   *
   * @param capSf 胶囊样式后缀
   * @param style 样式配置
   */
  public setCapComViewStyle(capSf: CapStyleSuffix, style: WidgetStyleStateV2): void {
    if (!style) {
      return;
    }
    let config = this.capComViewStyle.get(capSf);
    if (config) {
      config.bindBpConfig(style.getBpSplice(), style);
    } else {
      this.capComViewStyle.set(capSf, StyleStateConfig.wrap(capSf).bindBpConfig(style.getBpSplice(), style));
    }
  }

  /**
   * 取值胶囊样式配置
   *
   * @param bpSplice 屏幕断点拼接
   * @returns 样式配置
   */
  public getCapRootStyle(bpSplice?: SizeBpSplice): WidgetStyleStateV2 {
    let bpResult = bpSplice ?? SizeBpSplice.DEFAULT;
    let style = this.capRootStyle.getBpConfig(bpResult);
    if (style) {
      return style;
    }
    // 无对应场景时，取默认值
    return this.capRootStyle.getConfig() ?? CAP_DEFAULT_STYLE;
  }

  /**
   * 取值胶囊默认配置
   *
   * @param bpSplice 屏幕断点拼接
   * @returns 胶囊配置
   */
  public getCapConfig(bpSplice?: SizeBpSplice): SlCapConfigStateV2 {
    let bpResult = bpSplice ?? SizeBpSplice.DEFAULT;
    let config = this.capConfig.getBpConfig(bpResult);
    if (config) {
      return config;
    }
    // 无对应场景时，取默认值
    return this.capConfig.getConfig() ?? CAP_DEFAULT_CONFIG;
  }

  /**
   * 取值胶囊条目样式配置
   *
   * @param capType 胶囊类型
   * @param bpSplice 屏幕断点拼接
   * @returns 样式配置
   */
  public getCapItemStyle(capType: CapShowType, bpSplice?: SizeBpSplice): WidgetStyleStateV2 {
    let bpResult = bpSplice ?? SizeBpSplice.DEFAULT;
    let config = this.capItemStyle.get(capType);
    return (config?.getBpConfig(bpResult) ?? config?.getConfig()) ?? CAP_CONTENT_STYLE;
  }

  /**
   * 取值胶囊通用布局样式配置
   *
   * @param capSf 胶囊样式后缀
   * @param bpSplice 屏幕断点拼接
   * @returns 样式配置
   */
  public getCapComViewStyle(capSf: CapStyleSuffix, bpSplice?: SizeBpSplice): WidgetStyleStateV2 | undefined {
    let bpResult = bpSplice ?? SizeBpSplice.DEFAULT;
    let config = this.capComViewStyle.get(capSf);
    return config?.getBpConfig(bpResult) ?? config?.getConfig();
  }
}