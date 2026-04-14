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

import { WindowConstants } from '@ohos/commonconstants';
import curves from '@ohos.curves';

/**
 * 通知配置参数
 *
 * @since 2022-12-21
 */
export class NotificationConfig {
  /**
   * 通知内容文本，最大1行
   */
  public static readonly ITEM_CONTENT_SINGLE_LINE = 1;

  /**
   * 通知内容文本，最大3行
   */
  public static readonly ITEM_CONTENT_MAX_LINE_PHONE = 3;

  /**
   * 无通知时删除按钮透明图
   */
  public static readonly NTF_EMPTY_CLEAR_ICON_ALPHA = 0.4;

  /**
   * 通知展开/收起图标透明图
   */
  public static readonly NTF_ARROW_ICON_ALPHA = 0.6;

  /**
   * 有通知时删除按钮透明度
   */
  public static readonly NTF_CLEAR_ICON_ALPHA = 1.0;

  /**
   * 比重1
   */
  public static readonly LAYOUT_WEIGHT_ONE = 1;

  /**
   * 背景阴影radius
   */
  public static readonly ITEM_BG_SHADOW_RADIUS = WindowConstants.SHADOW_RADIUS;

  /**
   * 阴影颜色
   */
  public static readonly ITEM_BG_SHADOW_COLOR = WindowConstants.SHADOW_COLOR;

  /**
   * 阴影偏移X
   */
  public static readonly ITEM_BG_SHADOW_OFFSET_X = WindowConstants.SHADOW_OFFSET_X;

  /**
   * 阴影偏移Y
   */
  public static readonly ITEM_BG_SHADOW_OFFSET_Y = WindowConstants.SHADOW_OFFSET_Y;

  /**
   * 横幅阴影偏移X
   */
  public static readonly BANNER_SHADOW_OFFSET_X = WindowConstants.BANNER_SHADOW_OFFSET_X;

  /**
   * 横幅阴影偏移Y
   */
  public static readonly BANNER_SHADOW_OFFSET_Y = WindowConstants.BANNER_SHADOW_OFFSET_Y;

  /**
   * 横幅阴影颜色
   */
  public static readonly BANNER_SHADOW_COLOR = WindowConstants.BANNER_SHADOW_COLOR;

  /**
   * 横幅阴影半径
   */
  public static readonly BANNER_SHADOW_RADIUS = WindowConstants.BANNER_SHADOW_RADIUS;

  /**
   * 横幅窗口上下预留大投影显示空间，单位vp
   */
  public static readonly BANNER_MARGIN_BOTTOM = 20;

  /**
   * 横幅窗口左右预留大投影显示空间，单位vp
   */
  public static readonly BANNER_MARGIN_LEFT_RIGHT = 12;

  /**
   * 横幅窗口顶部间距，单位vp
   */
  public static readonly BANNER_TOP = 39;

  /**
   * 横幅窗口宽度，单位vp
   */
  public static readonly BANNER_WIDTH = 340;

  /**
   * 横幅窗口高度，单位vp
   */
  public static readonly BANNER_HEIGHT = 100;

  /**
   * 通知栏显示圆角弧度
   */
  public static readonly BORDER_RADIUS = 20;

  /**
   * pad锁屏通知宽度
   */
  public static readonly WIDTH_FOR_PAD = '48%';

  /**
   * 折叠屏锁屏通知宽度
   */
  public static readonly WIDTH_FOR_FOLD = '72%';

  /**
   * 手机锁屏通知宽度
   */
  public static readonly WIDTH_FOR_PHONE = '87%';


  /**
   * 列表预加载个数
   */
  public static readonly LIST_CACHE_COUNT = 7;

  /**
   * 横幅上滑阈值隐藏
   */
  public static readonly HIDE_HEADS_UP_DISTANCE = 40;
  /**
   * 沉浸态横幅上滑阈值隐藏
   */
  public static readonly HIDE_HEADS_UP_DISTANCE_IMMERSIVE = 10;

  /**
   * 横幅上滑隐藏高度
   */
  public static readonly HIDE_HEADS_UP_ANIM_DISTANCE = -40;

  /**
   * 横幅backgroundEffect模糊半径
   */
  public static readonly HEADS_UP_BACKGROUND_RADIUS = 57;

  /**
   * 横幅backgroundEffect灰阶参数
   */
  public static readonly HEADS_UP_BLUR_OPTIONS_GRAYSCALE = 38;

  /**
   * 横幅卡片默认亮度
   */
  public static readonly HEADS_UP_BRIGHTNESS = 1;

  /**
   * 横幅出现、消失动效，垂直方向默认起始值
   */
  public static readonly HEADS_UP_EFFECT_TRAN_Y = -420;

  /**
   * 横幅出现动效时长
   */
  public static readonly HEADS_UP_SHOW_DURATION = 1000;

  /**
   * 横幅收起动效时长
   */
  public static readonly HEADS_UP_HIDE_DURATION = 600;

  /**
   * 横幅消失动效时长
   */
  public static readonly HEADS_UP_DISAPPEAR_DURATION = 200;

  /**
   * 横幅出现动效参数
   */
  public static readonly HEADS_UP_SHOW_ANIM_PARAM: AnimateParam = {
    curve: curves.interpolatingSpring(0, 1, 80, 14),
  };

  /**
   * 横幅收起动效参数
   */
  public static readonly HEADS_UP_HIDE_ANIM_PARAM: AnimateParam = {
    duration: NotificationConfig.HEADS_UP_HIDE_DURATION,
    curve: curves.cubicBezierCurve(0.4, 0.0, 0.4, 1.0)
  };

  /**
   * 横幅消失动效参数
   */
  public static readonly HEADS_UP_DISAPPEAR_ANIM_PARAM: AnimateParam = {
    delay: 300,
    duration: NotificationConfig.HEADS_UP_DISAPPEAR_DURATION,
    curve: Curve.Friction
  };
  /**
   * 横幅点击进入中景窗动效
   */
  public static readonly HEADS_UP_MIDSCENE_DISAPPEAR_ANIM_TRANSITION_EFFECT = TransitionEffect.OPACITY
    .animation({ curve: Curve.Linear, duration: 100 })
    .combine(TransitionEffect
      .scale({ x: 0.75, y: 0.75 }).animation({ curve: Curve.Friction, duration: 200 }));

  /**
   * 横幅消失转场动效，适用于已有通知新来通知
   */
  public static readonly HEADS_UP_DISAPPEAR_ANIM_TRANSITION_EFFECT = TransitionEffect.OPACITY
    .animation({ delay: 300, curve: Curve.Linear, duration: 100 })
    .combine(TransitionEffect
      .scale({ x: 0.9, y: 0.9 }).animation(NotificationConfig.HEADS_UP_DISAPPEAR_ANIM_PARAM));

  /**
   * 横幅退场转场动效，适用于单通知正常向上退出
   */
  public static readonly HEADS_UP_HIDE_ANIM_TRANSITION_EFFECT = TransitionEffect
    .translate({ x: 0, y: NotificationConfig.HEADS_UP_EFFECT_TRAN_Y })
    .animation(NotificationConfig.HEADS_UP_HIDE_ANIM_PARAM);

  /**
   * 通知卡片按压点击动效
   */
  public static readonly NOTIFICATION_CLICK_ANIM: AnimateParam = {
    curve: curves.interpolatingSpring(10, 1, 350, 35)
  };

  /**
   * 卡片按压效果复位平滑动效
   */
  public static readonly NOTIFICATION_SCALE_ANIM: AnimateParam = {
    duration: 200,
    curve: Curve.Linear,
    playMode: PlayMode.Normal
  };

  /**
   * 设置弹出菜单出现动效
   */
  public static readonly SETTING_DIALOG_APPEAR_ANIM_TRANSITION_EFFECT = TransitionEffect.scale({ x: 0.95, y: 0.95 })
    .animation({ duration: 350, curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1) })
    .combine(TransitionEffect.opacity(0)
      .animation({ duration: 350, curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1) }));

  /**
   * 设置弹出菜单消失动效
   */
  public static readonly SETTING_DIALOG_DISAPPEAR_ANIM_TRANSITION_EFFECT = TransitionEffect.scale({ x: 0.95, y: 0.95 })
    .animation({ duration: 100, curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1) })
    .combine(TransitionEffect.opacity(0)
      .animation({ duration: 100, curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1) }));

}