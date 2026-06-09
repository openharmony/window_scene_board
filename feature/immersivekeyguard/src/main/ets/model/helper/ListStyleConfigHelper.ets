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
import { NotificationConfig } from '@ohos/notificationcomponent/src/main/ets/common/NotificationConfig';
import { SizeBpSplice, WBaseProperty } from '@ohos/screenlockcommon';
import { BaseState, SlStateId, StateModeId } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import {
  ColumnGutter,
  ColumnType,
  StyleStateConfig,
  WidgetStyleStateV2
} from '@ohos/screenlockcommon/Index';
import { BrightnessOptionUtils, LiveStyle } from '@ohos/systemuicommon/Index';
import { ListStyleSuffix } from '../../common/constants/ImmListConst';
import { IListStyleConfigHelper } from '../../common/interface/IListStyleConfigHelper';
import { SlListConfigStateV2 } from '../data/v2/SlListConfigStateV2';
import { SlListStateConfig } from '../data/v2/SlListStateConfig';

// 列表默认样式
const LIST_DEFAULT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setWidth('100%').setHeight('100%')
  .setPaddingT(16).setPaddingB(16).setPaddingL(16).setPaddingR(16);

// 列表大折叠展开态样式
const LIST_MM_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.MM)
  .setBpSplice(SizeBpSplice.MM).setWidth(532).setHeight('100%')
  .setPaddingT(16).setPaddingB(16);

// 列表PAD竖屏样式
const LIST_ML_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.ML)
  .setBpSplice(SizeBpSplice.ML).setWidth(532).setHeight('100%')
  .setPaddingT(16).setPaddingB(16);

// 列表PAD横屏样式
const LIST_LS_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.LS)
  .setBpSplice(SizeBpSplice.LS).setWidth(532).setHeight('100%')
  .setPaddingT(16).setPaddingB(16);

// 列表默认配置
const LIST_DEFAULT_CONFIG = BaseState.wrap<SlListConfigStateV2>(SlListConfigStateV2)
  .setTopClockHeight(124).setBottomToolsHeight(100);

// 列表PAD横屏配置
const LIST_LS_CONFIG = BaseState.wrap<SlListConfigStateV2>(SlListConfigStateV2).setBpSplice(SizeBpSplice.LS)
  .setTopClockHeight(124).setBottomToolsHeight(100)
  .setGutterConfig(ColumnGutter.getDefault(ColumnType.LG).updateColumn(6));

// 纯色模式、禁用提亮模式下AOD样式
const ITEM_SOLID_BRIGHT_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setBgColor('#ff1e1e1e')
  .buildCfgPtNull(WBaseProperty.BG_BRIGHTNESS_INNER);

// 列表条目布局默认样式
const LIST_ITEM_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setPointLight({illuminated: IlluminatedType.BORDER})
  .setBorderRadiusTL(NotificationConfig.BORDER_RADIUS)
  .setShadow({
    radius: 30, // 阴影半径
    color: '#19000000',
    offsetX: 0,
    offsetY: 10
  })
  .addChildState( // AOD场景样式，其他场景复用通知中心
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setBgColor('#ff1e1e1e')
      .setBgBrightnessInner(BrightnessOptionUtils.aodScreenNtfBaseboardLightOption)
  ).addChildState( // 纯色模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.SOLID)
      .addChildState(ITEM_SOLID_BRIGHT_AOD)
  )
  .addChildState( // 禁用提亮模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DIS_BRIGHT)
      .addChildState(ITEM_SOLID_BRIGHT_AOD)
  );

// 纯色模式、禁用提亮模式下AOD样式
const ITEM_TITLE_SOLID_BRIGHT_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setFontColor('#66ffffff')
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS);

// 列表条目主文本样式
const LIST_ITEM_TITLE_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState( // AOD场景样式，其他场景复用通知中心
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setFontColor('#66ffffff')
      .setFgBrightness(BrightnessOptionUtils.aodTimeLightOptionForFillColor)
  ).addChildState( // 纯色模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.SOLID)
      .addChildState(ITEM_TITLE_SOLID_BRIGHT_AOD)
  )
  .addChildState( // 禁用提亮模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DIS_BRIGHT)
      .addChildState(ITEM_TITLE_SOLID_BRIGHT_AOD)
  );

// 纯色模式、禁用提亮模式下AOD样式
const ITEM_CONTENT_SOLID_BRIGHT_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setFontColor('#4dffffff')
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS);

// 列表条目副文本样式
const LIST_ITEM_CONTENT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setBorderRadiusTL(NotificationConfig.BORDER_RADIUS)
  .addChildState( // AOD场景样式，其他场景复用通知中心
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setFontColor('#4dffffff')
      .setFgBrightness(BrightnessOptionUtils.aodTimeLightOptionForFillColor)
  ).addChildState( // 纯色模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.SOLID)
      .addChildState(ITEM_CONTENT_SOLID_BRIGHT_AOD)
  )
  .addChildState( // 禁用提亮模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DIS_BRIGHT)
      .addChildState(ITEM_CONTENT_SOLID_BRIGHT_AOD)
  );

// APP Icon布局默认样式
const LIST_ITEM_ICON_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setVisibility(Visibility.None) // 背板的可见性
  .setBgColor('#00000000') // 背板颜色
  .addChildState( // AOD下Icon样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setAlpha(0.4) // 图标的透明度
      .setVisibility(Visibility.Visible) // 背板的可见性
      .setBgColor('#FF000000') // 背板颜色
      .setColorFilter(LiveStyle.WHITE_COLOR_FILTER) // 导航图标反色
  )
  .addChildState( // 深色模式下Icon样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DARK)
      .setVisibility(Visibility.None) // 背板的可见性
      .setBgColor('#00000000') // 背板颜色
  );

// 三方实况扩展区标题文本样式
const EXT_TITLE_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState( // AOD下标题文本样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setFontColor('#66FFFFFF')
  );

// 三方实况扩展区内容文本样式
const EXT_CONTENT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState( // AOD下内容文本样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setFontColor('#4DFFFFFF')
  );

// 纯色模式、禁用提亮模式下AOD样式
const EXT_DIVIDER_SOLID_BRIGHT_AOD = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
  .setAlpha(0.1)
  .setFillColor($r('sys.color.ohos_id_color_list_separator'))
  .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS);

// 三方实况扩展区分割线样式
const EXT_DIVIDER_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState( // AOD下分割线样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setAlpha(0.1)
      .setFillColor($r('sys.color.ohos_id_color_list_separator'))
      .setFgBrightness(BrightnessOptionUtils.getInstance().foregroundDividerDarkOption)
  )
  .addChildState( // 纯色模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.SOLID)
      .addChildState(EXT_DIVIDER_SOLID_BRIGHT_AOD)
  )
  .addChildState( // 禁用提亮模式下样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.DIS_BRIGHT)
      .addChildState(EXT_DIVIDER_SOLID_BRIGHT_AOD)
  );

// 三方实况扩展区服务按钮样式
const EXT_ACTION_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState( // AOD下服务按钮样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setAlpha(0.1)
      .setFontColor('#99ffffff')
  );

// 三方实况扩展区鉴权按钮样式
const EXT_AUTHOR_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState( // AOD下鉴权按钮样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setAlpha(0.4)
      .setFontColor('#99ffffff')
      .setBrightness(1)
      .setBgColor('#26000000')
  );

// 三方实况取餐卡片扩展区副文本样式
const EXT_PICKUP_CON_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState( // AOD下副文本样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setFontSize(16)
      .setMarginB(0)
      .setFontWeight(FontWeight.Medium)
  );

// 三方实况比分卡片扩展区计时样式
const EXT_SCORE_TIMER_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setWidth(50);

// 三方实况扩展区样式
const OTHER_LIVE_EXTEND_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState( // AOD下扩展区样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setAlpha(0.4)
  );

// 普通通知时间文本样式
const LIST_ITEM_TIME_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .setVisibility(Visibility.Visible)
  .addChildState( // AOD下时间文本样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setVisibility(Visibility.Hidden)
  );

// 系统实况副文本样式
const SYS_LIVE_CONTENT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState( // AOD下按钮样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .buildCfgPtNull(WBaseProperty.FG_BRIGHTNESS)
      .setFgColor('#4DFFFFFF')
  );

// 系统实况按钮样式
const SYS_LIVE_BUTTON_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState( // AOD下按钮样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setAlpha(0.1)
  );

// 系统实况进度环样式
const SYS_LIVE_PROGRESS_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState( // AOD下进度环样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setAlpha(0.4)
  );

// 三方实况辅助区文本样式
const OTHER_EXT_VIEW_TEXT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState( // AOD下辅助区文本样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setFontColor('#66FFFFFF')
      .setAlpha(0.4)
      .setFgBrightness(BrightnessOptionUtils.aodTimeLightOptionForFillColor)
      .setRenderGroup(false)
  )

// 三方实况辅助区文本带wantAgent样式
const OTHER_EXT_VIEW_TEXT_WANT_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState( // AOD下辅助区文本带wantAgent样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setAlpha(0.1)
  )

// 三方实况辅助区按钮样式
const OTHER_EXT_VIEW_BUTTON_STYLE = BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, SizeBpSplice.DEFAULT)
  .addChildState( // AOD下辅助区按钮样式
    BaseState.wrap<WidgetStyleStateV2>(WidgetStyleStateV2, StateModeId.AOD)
      .setBgColor($r('app.color.ntf_brightness_bg_color'))
      .setBgBrightnessInner(BrightnessOptionUtils.getInstance().aodTimeLightOptionForButtonBgColor)
      .setAlpha(0.3)
  )

/**
 * 沉浸列表样式默认配置辅助工具
 */
export class ListStyleConfigH implements IListStyleConfigHelper {
  // 列表扩展配置
  private readonly listConfig: SlListStateConfig = SlListStateConfig.wrap(SlStateId.SL_LIST_STATE)
    .bindBpConfig(SizeBpSplice.DEFAULT, LIST_DEFAULT_CONFIG)
    .bindBpConfig(SizeBpSplice.LS, LIST_LS_CONFIG)
    .bindBpConfig(SizeBpSplice.XS, LIST_LS_CONFIG);

  // 列表根布局样式配置
  private readonly listRootStyle: StyleStateConfig = StyleStateConfig.wrap(SlStateId.SL_LIST_STATE)
    .bindBpConfig(SizeBpSplice.DEFAULT, LIST_DEFAULT_STYLE)
    .bindBpConfig(SizeBpSplice.MM, LIST_MM_STYLE)
    .bindBpConfig(SizeBpSplice.ML, LIST_ML_STYLE)
    .bindBpConfig(SizeBpSplice.LL, LIST_ML_STYLE)
    .bindBpConfig(SizeBpSplice.LS, LIST_LS_STYLE)
    .bindBpConfig(SizeBpSplice.XS, LIST_LS_STYLE);

  // 列表通用布局样式配置
  private readonly listComViewStyle: Map<ListStyleSuffix, StyleStateConfig> = new Map([
    [ // 内部通用布局样式
      ListStyleSuffix.ITEM_COMMON_STYLE,
      StyleStateConfig.wrap(ListStyleSuffix.ITEM_COMMON_STYLE).bindConfig(LIST_ITEM_STYLE)
    ],
    [ // 主文本样式
      ListStyleSuffix.ITEM_TITLE_STYLE,
      StyleStateConfig.wrap(ListStyleSuffix.ITEM_TITLE_STYLE).bindConfig(LIST_ITEM_TITLE_STYLE)
    ],
    [ // 副文本样式
      ListStyleSuffix.ITEM_CONTENT_STYLE,
      StyleStateConfig.wrap(ListStyleSuffix.ITEM_CONTENT_STYLE).bindConfig(LIST_ITEM_CONTENT_STYLE)
    ],
    [ // icon样式
      ListStyleSuffix.ITEM_ICON_STYLE,
      StyleStateConfig.wrap(ListStyleSuffix.ITEM_ICON_STYLE).bindConfig(LIST_ITEM_ICON_STYLE)
    ],
    [ // 三方实况扩展区标题文本样式
      ListStyleSuffix.EXT_TITLE_STYLE,
      StyleStateConfig.wrap(ListStyleSuffix.EXT_TITLE_STYLE).bindConfig(EXT_TITLE_STYLE)
    ],
    [ // 三方实况扩展区内容文本样式
      ListStyleSuffix.EXT_CONTENT_STYLE,
      StyleStateConfig.wrap(ListStyleSuffix.EXT_CONTENT_STYLE).bindConfig(EXT_CONTENT_STYLE)
    ],
    [ // 三方实况扩展区分割线样式
      ListStyleSuffix.EXT_DIVIDER_STYLE,
      StyleStateConfig.wrap(ListStyleSuffix.EXT_DIVIDER_STYLE).bindConfig(EXT_DIVIDER_STYLE)
    ],
    [ // 三方实况扩展区服务按钮样式
      ListStyleSuffix.EXT_ACTION_STYLE,
      StyleStateConfig.wrap(ListStyleSuffix.EXT_ACTION_STYLE).bindConfig(EXT_ACTION_STYLE)
    ],
    [ // 三方实况扩展区鉴权按钮样式
      ListStyleSuffix.EXT_AUTHOR_STYLE,
      StyleStateConfig.wrap(ListStyleSuffix.EXT_AUTHOR_STYLE).bindConfig(EXT_AUTHOR_STYLE)
    ],
    [ // 三方实况取餐模板扩展区副文本样式
      ListStyleSuffix.EXT_PICKUP_CON_STYLE,
      StyleStateConfig.wrap(ListStyleSuffix.EXT_PICKUP_CON_STYLE).bindConfig(EXT_PICKUP_CON_STYLE)
    ],
    [ // 三方实况比分模板扩展区计时文本样式
      ListStyleSuffix.EXT_SCORE_TIMER_STYLE,
      StyleStateConfig.wrap(ListStyleSuffix.EXT_SCORE_TIMER_STYLE).bindConfig(EXT_SCORE_TIMER_STYLE)
    ],
    [ // 普通通知时间文本样式
      ListStyleSuffix.ITEM_TIME_STYLE,
      StyleStateConfig.wrap(ListStyleSuffix.ITEM_TIME_STYLE).bindConfig(LIST_ITEM_TIME_STYLE)
    ],
    [ // 系统实况副文本样式
      ListStyleSuffix.SYS_LIVE_CONTENT_STYLE,
      StyleStateConfig.wrap(ListStyleSuffix.SYS_LIVE_CONTENT_STYLE).bindConfig(SYS_LIVE_CONTENT_STYLE)
    ],
    [ // 系统实况按钮样式
      ListStyleSuffix.SYS_LIVE_BUTTON_STYLE,
      StyleStateConfig.wrap(ListStyleSuffix.SYS_LIVE_BUTTON_STYLE).bindConfig(SYS_LIVE_BUTTON_STYLE)
    ],
    [ // 系统实况进度环样式
      ListStyleSuffix.SYS_LIVE_PROGRESS_STYLE,
      StyleStateConfig.wrap(ListStyleSuffix.SYS_LIVE_PROGRESS_STYLE).bindConfig(SYS_LIVE_PROGRESS_STYLE)
    ],
    [ // 三方实况扩展区样式
      ListStyleSuffix.OTHER_LIVE_EXTEND_STYLE,
      StyleStateConfig.wrap(ListStyleSuffix.OTHER_LIVE_EXTEND_STYLE).bindConfig(OTHER_LIVE_EXTEND_STYLE)
    ],
    [ // 三方实况辅助区文本样式
      ListStyleSuffix.OTHER_EXT_VIEW_TEXT_STYLE,
      StyleStateConfig.wrap(ListStyleSuffix.OTHER_EXT_VIEW_TEXT_STYLE).bindConfig(OTHER_EXT_VIEW_TEXT_STYLE)
    ],
    [ // 三方实况辅助区文本带wantAgent样式
      ListStyleSuffix.OTHER_EXT_VIEW_WANT_STYLE,
      StyleStateConfig.wrap(ListStyleSuffix.OTHER_EXT_VIEW_WANT_STYLE).bindConfig(OTHER_EXT_VIEW_TEXT_WANT_STYLE)
    ],
    [ // 三方实况辅助区按钮样式
      ListStyleSuffix.OTHER_EXT_VIEW_BTN_STYLE,
      StyleStateConfig.wrap(ListStyleSuffix.OTHER_EXT_VIEW_BTN_STYLE).bindConfig(OTHER_EXT_VIEW_BUTTON_STYLE)
    ],
  ]);

  /**
   * 清空配置
   */
  public clearListConfig(): void {
    this.listConfig.clearConfig();
    this.listRootStyle.clearConfig();
    this.listComViewStyle.clear();
  }

  /**
   * 设置列表样式配置，用于产品差异化配置
   *
   * @param style 样式配置
   */
  public setListRootStyle(style: WidgetStyleStateV2): void {
    if (style) {
      this.listRootStyle.bindBpConfig(style.getBpSplice(), style);
    }
  }

  /**
   * 设置列表配置，用于产品差异化配置
   *
   * @param config 配置
   */
  public setListConfig(config: SlListConfigStateV2): void {
    if (config) {
      this.listConfig.bindBpConfig(config.getBpSplice(), config);
    }
  }

  /**
   * 赋值列表条目布局样式配置，用于多产品差异化配置
   *
   * @param listSf 样式后缀
   * @param style 样式配置
   */
  public setListItemStyle(listSf: ListStyleSuffix, style: WidgetStyleStateV2): void {
    if (!style) {
      return;
    }
    let config = this.listComViewStyle.get(listSf);
    if (config) {
      config.bindBpConfig(style.getBpSplice(), style);
    } else {
      this.listComViewStyle.set(listSf, StyleStateConfig.wrap(listSf).bindBpConfig(style.getBpSplice(), style));
    }
  }

  /**
   * 取值列表样式配置
   *
   * @param bpSplice 屏幕断点拼接
   * @returns 样式配置
   */
  public getListRootStyle(bpSplice?: SizeBpSplice): WidgetStyleStateV2 {
    let bpResult = bpSplice ?? SizeBpSplice.DEFAULT;
    let style = this.listRootStyle.getBpConfig(bpResult);
    if (style) {
      return style;
    }
    return this.listRootStyle.getConfig() ?? LIST_DEFAULT_STYLE;
  }

  /**
   * 取值列表配置
   *
   * @param bpSplice 屏幕断点拼接
   * @returns 配置
   */
  public getListConfig(bpSplice?: SizeBpSplice): SlListConfigStateV2 {
    let bpResult = bpSplice ?? SizeBpSplice.DEFAULT;
    let config = this.listConfig.getBpConfig(bpResult);
    if (config) {
      return config;
    }
    return this.listConfig.getConfig() ?? LIST_DEFAULT_CONFIG;
  }

  /**
   * 取值列表条目样式配置
   *
   * @param listSf 样式后缀
   * @param bpSplice 屏幕断点拼接
   * @returns 样式配置
   */
  public getListItemStyle(listSf: ListStyleSuffix, bpSplice: SizeBpSplice = SizeBpSplice.DEFAULT): WidgetStyleStateV2 {
    let config = this.listComViewStyle.get(listSf);
    return config?.getBpConfig(bpSplice) ?? LIST_ITEM_STYLE;
  }
}