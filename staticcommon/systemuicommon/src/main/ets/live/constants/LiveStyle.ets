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
import { curves } from '@kit.ArkUI';
import { drawing } from '@kit.ArkGraphics2D';
import { deviceInfo } from '@kit.BasicServicesKit';

export class LiveStyle {
  /**
   * 胶囊图片大小
   */
  public static readonly CAPSULE_ICON_SIZE = 18;

  /**
   * 胶囊默认宽度
   */
  public static readonly CAPSULE_WIDTH = 80;

  /**
   * 圆饼胶囊默认宽度
   */
  public static readonly CAPSULE_CIRCLE_WIDTH = 28;

  /**
   * 圆饼胶囊默认宽度
   */
  public static readonly CAPSULE_SMALL_CIRCLE_WIDTH = 24;

  /**
   * 阴影胶囊显示宽度
   */
  public static readonly SHADOW_CAPSULE_SHOW_WIDTH = 6;

  /**
   * 阴影胶囊宽度
   */
  public static readonly SHADOW_CAPSULE_CIRCLE_WIDTH = 26;

  /**
   * 阴影胶囊宽度
   */
  public static readonly SHADOW_CAPSULE_SMALL_OFFSET = 8;

  /**
   * 胶囊icon区域的宽度
   * icon 本身18 * 18
   * 但是可能传24 * 24的图片填充
   */
  public static readonly CAPSULE_ICON_WIDTH = 24;

  /**
   * 小胶囊icon区域的宽度
   * icon 本身16 * 16
   * 但是可能传20 * 20的图片填充
   */
  public static readonly CAPSULE_SMALL_ICON_WIDTH = 20;

  /**
   * 双端挂孔胶囊左右最小宽度（挖孔宽度小于胶囊宽度30%时使用）
   */
  public static readonly HANGING_HOLE_DOUBLE_ENDED_LEFT_RIGHT_MIN_WIDTH = 48;

  /**
   * 双端挂孔胶囊左右最小宽度（挖孔宽度大于胶囊宽度30%时使用）
   */
  public static readonly HANGING_HOLE_DOUBLE_ENDED_LEFT_RIGHT_MIN_WIDTH_WITHOUT_TEXT = 27;

  /**
   * 单文本双端挂孔胶囊右侧胶囊最大宽度
   */
  public static readonly HANGING_HOLE_DOUBLE_ENDED_SINGLE_TEXT_RIGHT_MAX_WIDTH = 62;

  /**
   * 双文本双端挂孔胶囊右侧胶囊最大宽度
   */
  public static readonly HANGING_HOLE_DOUBLE_ENDED_DOUBLE_TEXT_RIGHT_MAX_WIDTH = 84;

  /**
   * 播控单文本双端挂孔胶囊右侧胶囊最大宽度
   */
  public static readonly MEDIA_PLAYER_DOUBLE_ENDED_SINGLE_TEXT_RIGHT_MAX_WIDTH = 49;

  /**
   * 单端挂孔胶囊最小宽度（计算时会增加2的边距，左侧距离孔的整体最小就是72）
   */
  public static readonly HANGING_HOLE_MIN_WIDTH = 70;

  /**
   * 定制单端挂孔胶囊最小宽度（计算时会增加1的边距，左侧距离孔的整体最小就是68）
   */
  public static readonly HANGING_HOLE_MIN_CUSTOM_WIDTH = 67;

  /**
   * 胶囊最大宽度
   */
  public static readonly CAPSULE_MAX_WIDTH = 116;

  /**
   * 挂孔胶囊最大宽度
   */
  public static readonly HANGING_CAPSULE_MAX_WIDTH = 112;

  /**
   * 拓展态胶囊宽度
   */
  public static readonly CAPSULE_EXTEND_WIDTH: number = 114;

  /**
   * 拓展态胶囊最大宽度
   */
  public static readonly CAPSULE_EXTEND_MAX_WIDTH: number = 170;

  /**
   * 抢占态胶囊最大宽度
   */
  public static readonly CAPSULE_REMIND_MAX_WIDTH: number = 186;

  /**
   * 胶囊默认高度
   */
  public static readonly CAPSULE_HEIGHT = deviceInfo.productSeries.includes('ALN') ? 29 : 28;

  /**
   * 胶囊小外屏默认高度
   */
  public static readonly CAPSULE_SMALL_HEIGHT = 24;

  /**
   * 胶囊阴影默认高度
   */
  public static readonly CAPSULE_SHADOW_HEIGHT = 26;

  /**
   * 胶囊和状态栏之间的GAP（单孔时）, 单位vp
   */
  public static readonly CAPSULE_STATUS_BAR_GAP_SINGLE_HOLE = 4;

  /**
   * 胶囊和状态栏之间的GAP（多孔时）, 单位vp
   */
  public static readonly CAPSULE_STATUS_BAR_GAP_MULTI_HOLE = 4;

  /**
   * 胶囊和状态栏左侧GAP（无孔时）, 单位vp
   */
  public static readonly CAPSULE_LEFT_STATUS_BAR_GAP_WITHOUT_HOLE = 8;

  /**
   * 胶囊和状态栏之间的GAP（无孔时）, 单位vp
   */
  public static readonly CAPSULE_STATUS_BAR_GAP_WITHOUT_HOLE = 6;

  /**
   * 胶囊容器背板的颜色
   */
  public static readonly CAPSULE_CONTAINER_COLOR = '#1f000000';

  /**
   * 胶囊主题色
   */
  public static readonly CAPSULE_CONTENT_COLOR = '#bf000000';

  /**
   * 胶囊阴影主题色
   */
  public static readonly CAPSULE_SHADOW_COLOR = '#26000000';

  /**
   * 胶囊图标0间距，主要用于width=0，padding会将胶囊撑起的场景
   */
  public static readonly CAPSULE_ICON_ZERO_MARGIN = 0;

  /**
   * 胶囊图标间距
   */
  public static readonly CAPSULE_ICON_MARGIN = 5;

  /**
   * 圆饼的padding
   */
  public static readonly CAPSULE_ICON_PADDING = 2;

  /**
   * 胶囊文字间距
   */
  public static readonly CAPSULE_TEXT_MARGIN = 6;

  /**
   * 胶囊文字间距-小外屏
   */
  public static readonly CAPSULE_TEXT_MARGIN_OUTER_HOME = 4;

  /**
   * 挂孔胶囊文字间距
   */
  public static readonly HANGING_CAPSULE_TEXT_MARGIN = 4;

  /**
   * 胶囊上图标和文本之间的间距，图标大小为24x24
   */
  public static readonly CAPSULE_ICON_TEXT_MARGIN = 3;

  /**
   * 胶囊上从图标到文本之间的起始间距，图标大小为24x24
   */
  public static readonly CAPSULE_ICON_TEXT_MARGIN_START = 4;

  /**
   * 胶囊主副文本默认间距
   */
  public static readonly CAPSULE_TEXT_SPACE: number = 6;

  /**
   * 胶囊标题文本宽度
   */
  public static readonly CAPSULE_TITLE_WIDTH = 45;

  /**
   * 胶囊副文本区宽度
   */
  public static readonly CAPSULE_EXTEND_TEXT_WIDTH: number = 42;

  /**
   * 宽屏判断最小阈值，vp
   * 达到阈值，布局按宽屏布局处理
   */
  public static readonly WIDTH_THRESHOLD_SMALL = 600;

  /**
   * 胶囊标题文本宽度
   */
  public static readonly CAPSULE_TITLE_MAX_WIDTH = 45;

  /**
   * 胶囊默认层级
   */
  public static readonly CAPSULE_INDEX = -1;

  /**
   * 低优先级胶囊层级
   * 胶囊阴影、不显示的胶囊使用
   */
  public static readonly CAPSULE_LOW_INDEX = -2;

  /**
   * 竖屏进度类圆饼胶囊层级
   */
  public static readonly CAPSULE_ROUND_CAKE_INDEX = 1;

  /**
   * 胶囊文字默认大小
   */
  public static readonly CAPSULE_FONT_SIZE = 14;

  /**
   * 胶囊文字最小大小
   */
  public static readonly CAPSULE_FONT_MIN_SIZE = 12;

  /**
   * 胶囊圆角半径
   */
  public static readonly CAPSULE_RADIUS = 16;

  /**
   * 胶囊文字默认字体
   */
  public static readonly CAPSULE_FONT_FAMILY: string = 'HarmonyHeiTi';

  /**
   * 胶囊文字粗细
   */
  public static readonly CAPSULE_FONT_WEIGHT: FontWeight = FontWeight.Medium;

  /**
   * 胶囊进度环图标大小
   */
  public static readonly CAPSULE_PROGRESS_ICON_WIDTH: number = 14;

  /**
   * 胶囊进度环图标大小
   */
  public static readonly CAPSULE_PROGRESS_STROKE_WIDTH: number = 3.5;

  /**
   * 胶囊进度环背景颜色
   */
  public static readonly CAPSULE_PROGRESS_BACKGROUND_COLOR = '#40ffffff';

  /**
   * 卡片小图标尺寸
   */
  public static readonly CARD_SMALL_ICON_SIZE = 16;

  /**
   * 卡片图标尺寸
   */
  public static readonly CARD_ICON_SIZE = 32;

  /**
   * 卡片圆角
   */
  public static readonly CARD_RADIUS = 20;

  /**
   * 卡片列表间距
   */
  public static readonly CARD_LIST_SPACE = 8;

  /**
   * 卡片列表底部高度
   */
  public static readonly CARD_LIST_BOTTOM_HEIGHT = 14;

  /**
   * 实况卡片菜单宽度
   */
  public static readonly CARD_MENU_BUTTON_WIDTH = 40;

  /**
   * 实况卡片菜单高度
   */
  public static readonly CARD_MENU_BUTTON_HEIGHT = LiveStyle.CARD_MENU_BUTTON_WIDTH;

  /**
   * 实况菜单间距
   */
  public static readonly CARD_MENU_MARGIN = 12;
  /**
   * 扫光动效宽度
   */
  public static readonly WAVE_WIDTH: number = 32;
  /**
   * 扫光波浪组件透明度
   */
  public static readonly MOVE_WAVE_OPACITY: number = 0.8;
  /**
   * 抢占类胶囊数据清理时间/前台展示最短时间，默认3.5s
   */
  public static readonly INSTANT_LIVE_TIMEOUT = 3500;
  /**
   * 抢占类胶囊清理时间/前台展示最长时间，默认10s
   */
  public static readonly INSTANT_MAX_SHOW_TIME = 10000;
  /**
   * sim卡上边距
   */
  public static readonly CARD_SIM_PADDING_TOP = 1;
  /**
   * sim卡下边距
   */
  public static readonly CARD_SIM_PADDING_BOTTOM = 2;
  /**
   * sim卡右边距
   */
  public static readonly CARD_SIM_PADDING_RIGHT = 2;
  /**
   * 系统实况列表高度
   */
  public static readonly LIVE_SYSTEM_CARD_HEIGHT = 66;
  /**
   * 三方实况固定区高度
   */
  public static readonly LIVE_OTHER_CARD_FIXED_HEIGHT = 72;
  /**
   * 三方实况列表高度
   */
  public static readonly LIVE_OTHER_CARD_HEIGHT = 144;
  /**
   * 卡片padding值
   */
  public static readonly CARD_PADDING = $r('app.float.live_view_card_padding');
  /**
   * 卡片文本行高
   */
  public static readonly CARD_TEXT_LINE_HEIGHT = $r('app.float.live_view_card_text_line_height');
  /**
   * 实况卡片或横幅在横屏/竖屏布局下固定宽度为328
   */
  public static readonly CARD_WIDTH = 328;
  /**
   * 实况钱包卡片固定高度
   */
  public static readonly WALLET_CARD_HEIGHT = 48;
  /**
   * 实况钱包卡片小卡宽度
   */
  public static readonly WALLET_SMALL_CARD_WIDTH = 76;
  /**
   * 卡片文本颜色
   */
  public static readonly CARD_TEXT_FONT_COLOR = $r('sys.color.ohos_id_color_text_primary');
  /**
   * 卡片标题颜色
   */
  public static readonly CARD_TITLE_FONT_COLOR = $r('sys.color.ohos_id_color_text_primary');
  /**
   * 三方卡片扩展区文本字体大小
   */
  public static readonly PICKUP_EXTEND_TIMER_FONT_SIZE = 26;
  /**
   * 三方卡片左右模板角标文本字体大小
   */
  public static readonly FLIGHT_BADGE_FONT_SIZE = $r('sys.float.ohos_id_text_size_caption');
  /**
   * 三方卡片左右模板中间文本边框颜色
   */
  public static readonly FLIGHT_SPACE_TEXT_BORDER_COLOR = $r('app.color.flight_template_space_text_border_color');
  /**
   * 三方卡片左右模板中间文本字体大小
   */
  public static readonly FLIGHT_SPACE_TEXT_FONT_SIZE = $r('sys.float.ohos_id_text_size_body3');
  /**
   * 三方卡片左右模板中间文本字体颜色
   */
  public static readonly FLIGHT_SPACE_TEXT_FONT_COLOR = $r('app.color.flight_template_space_text_color');
  /**
   * 三方卡片左右模板中间文本最大宽度
   */
  public static readonly FLIGHT_SPACE_TEXT_MAX_WIDTH = $r('app.float.live_view_card_flight_space_text_max_width');
  /**
   * 三方卡片左右模板中间文本水平内间距
   */
  public static readonly FLIGHT_SPACE_TEXT_PADDING_X = $r('app.float.live_view_card_flight_space_text_padding_horizontal');
  /**
   * 三方卡片左右模板中间文本垂直内间距
   */
  public static readonly FLIGHT_SPACE_TEXT_PADDING_Y = $r('app.float.live_view_card_flight_space_text_padding_vertical');
  /**
   * 三方卡片左右模板中间文本水平外间距
   */
  public static readonly FLIGHT_SPACE_TEXT_MARGIN_X = $r('app.float.live_view_card_flight_space_text_margin');
  /**
   * 系统实况卡片文本内容字体大小
   */
  public static readonly SYSTEM_CARD_TEXT_FONT_SIZE = $r('sys.float.ohos_id_text_size_body2');
  /**
   * 系统文本颜色二级
   */
  public static readonly SYS_TEXT_COLOR_SECONDARY = $r('sys.color.ohos_id_color_text_secondary');
  /**
   * sim卡1symbol资源
   */
  public static readonly SIM1_SYMBOL_RESOURCE = $r('sys.symbol.simcard_1');
  /**
   * sim卡2symbol资源
   */
  public static readonly SIM2_SYMBOL_RESOURCE = $r('sys.symbol.simcard_2');
  /**
   * 实况卡片标题颜色
   */
  public static readonly LIVE_CARD_TITLE_FONT_COLOR = 'rgba(255,255,255,0.9)';
  /**
   * 实况卡片文本颜色
   */
  public static readonly LIVE_CARD_TEXT_FONT_COLOR = 'rgba(255,255,255,0.6)';
  /**
   *三方卡片左侧图标圆角
   */
  public static readonly LEFT_LARGE_ICON_RADIUS: Resource = $r('app.float.live_view_left_large_icon_radius');
  /**
   * 胶囊回孔后动效中转位移
   */
  public static readonly CAPSULE_TRANSFER_OFFSET = 0;
  /**
   * 挂孔胶囊回孔后动效中转缩小比例
   */
  public static readonly LEFT_HOLE_CAPSULE_TRANSFER_SCALE = 0.4;
  /**
   * 挂孔胶囊回孔后动效中转透明度
   */
  public static readonly LEFT_HOLE_CAPSULE_TRANSFER_OPACITY = 0;
  /**
   * 胶囊描边宽度
   */
  public static readonly CAPSULE_OUTLINE_WIDTH = 0.8;
  /**
   * 胶囊描边颜色
   */
  public static readonly CAPSULE_OUTLINE_COLOR = 'rgba(255, 255, 255, 0.2)';
  /**
   * 非挂孔胶囊背板颜色
   */
  public static readonly CAPSULE_BACKGROUND_COLOR = 'rgba(0, 0, 0, 0.7)';
  /**
   * 阴影胶囊颜色 跟随状态栏图标，分别取黑白色的30%透明度
   */
  public static readonly SHADOW_CAPSULE_WHITE_COLOR = 'rgba(255, 255, 255, 0.3)';
  public static readonly SHADOW_CAPSULE_BLACK_COLOR = 'rgba(0, 0, 0, 0.3)';

  public static readonly LIVE_BUTTON_ON_BRIGHTNESS_BG_COLOR = '#e7ffffff';
  /**
   * 阴影胶囊与圆饼外描边之间的距离
   */
  public static readonly SHADOW_CAPSULE_WIDTH = 7.2;

  /**
   * 阴影胶囊与圆饼外描边之间的距离
   */
  public static readonly SHADOW_CAPSULE_SMALL_WIDTH = 5.2;

  /**
   * 融球左侧到胶囊右侧之间的距离
   */
  public static readonly CAPSULE_LEFT_HOLE_WIDTH = 26;

  /**
   * 天气胶囊最小字体大小
   */
  public static readonly WEATHER_CAPSULE_TEXT_MIN_SIZE = 9;

  /**
   * 天气icon最小字体大小
   */
  public static readonly WEATHER_CAPSULE_ICON_MIN_SIZE = 10;

  /**
   * 天气图标胶囊最小宽度
   */
  public static readonly WEATHER_ICON_MIN_WIDTH = 28;

  /**
   * 天气胶囊左、上、下margin
   */
  public static readonly WEATHER_CAPSULE_MARGIN = 2;

  /**
   * 天气动效普通持续时长, 默认5s
   */
  public static readonly WEATHER_NORMAL_ANIMATION_DURATION = 5000;

  /**
   * 天气动效AOD持续时长，默认2s
   */
  public static readonly WEATHER_AOD_ANIMATION_DURATION = 2000;

  /**
   * 进度类动画开始时延，默认250ms
   */
  public static readonly PROGRESS_ANIMATION_DELAY = 250;

  /**
   * 天气胶囊右margin
   */
  public static readonly WEATHER_CAPSULE_RIGHT_MARGIN = 4;
  /**
   * 融球动效执行到高度最高时的时长
   */
  public static readonly METABALL_HIGHEST_DURATION = 233;
  /**
   * banner左右间距，vp
   * 预留空间处理投影
   */
  public static readonly MARGIN_LEFT_RIGHT: number = 16;
  /**
   * 沉浸式横屏场景，banner顶部间距，vp
   */
  public static readonly MARGIN_TOP_IN_IMMERSIVE: number = 8;
  /**
   * 扩展折叠设备外屏场景，相对于内屏实况列表的位置，应该向上偏移3VP
   */
  public static readonly MARGIN_TOP_OUTER_HOME_FOLD: number = -3;
  /**
   * 普通场景，banner距离状态栏高度，vp
   */
  public static readonly MARGIN_STATUS_BAR_TOP: number = 8;
  /**
   * 全场景实况通知卡片跳转参数
   */
  public static readonly DISTRIBUTE_OPERATION_CARD_JUMP: number = 32;
  /**
   * 全场景实况通知按钮跳转参数
   */
  public static readonly DISTRIBUTE_OPERATION_BUTTON_JUMP: number = 33;
  /**
   * 人脸解锁横幅大小
   */
  public static readonly FACE_LOCK_BANNER_SIZE: number = 88;
  /**
   * 人脸解锁横幅boarder
   */
  public static readonly FACE_LOCK_BANNER_BOARDER_SIZE: number = 24;
  /**
   * 人脸胶囊认证中缩放指数
   */
  public static readonly FACE_LOCK_SHOW_CAPSULE_SCALE: number = 1.4;
  /**
   * 人脸胶囊认证成功缩放指数
   */
  public static readonly FACE_LOCK_SUCCESS_CAPSULE_SCALE: number = 1.8;
  /**
   * 胶囊主副文本分隔符组件宽度
   */
  public static readonly CAPSULE_SEPARATOR_WIDTH: number = 6;
  /**
   * 小外屏胶囊主副文本分隔符组件宽度
   */
  public static readonly CAPSULE_SMALL_SEPARATOR_WIDTH: number = 4;
  /**
   * 图片资源赋色
   */
  public static readonly WHITE_COLOR_FILTER = drawing.ColorFilter.createBlendModeColorFilter(
    { alpha: 255, red: 255, green: 255, blue: 255 }, drawing.BlendMode.SRC_IN);
  public static readonly BLACK_COLOR_FILTER = drawing.ColorFilter.createBlendModeColorFilter(
    { alpha: 255, red: 0, green: 0, blue: 0 }, drawing.BlendMode.SRC_IN);
  /**
   * 实况卡片进度环背景颜色
   */
  public static readonly PROGRESS_BACKGROUND_COLOR = '#14000000';
  /**
   * 实况卡片进度环颜色，LIGHT/brand
   */
  public static readonly PROGRESS_COLOR_LIGHT = '#0A59F7';
  /**
   * 实况卡片进度环颜色，DARK/brand
   */
  public static readonly PROGRESS_COLOR_DARK = '#317AF7';
  /**
   * 组件转场动效
   */
  public static readonly LIVE_CARD_TRANSITION = TransitionEffect.asymmetric(
    TransitionEffect.OPACITY
      .animation({
        delay: 83,
        duration: 187,
        curve: curves.interpolatingSpring(0, 1, 228, 23),
      })
      .combine(TransitionEffect.opacity(0))
      .combine(TransitionEffect.scale({
        x: 0.6,
        y: 0.6
      })),
    TransitionEffect.OPACITY
      .animation({
        duration: 187,
        curve: curves.interpolatingSpring(0, 1, 228, 23),
      })
      .combine(TransitionEffect.opacity(0))
      .combine(TransitionEffect.scale({
        x: 0.6,
        y: 0.6
      }))
  );
}