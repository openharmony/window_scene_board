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

import curves from '@ohos.curves';

/*
 * 默认单位px
 * */
export default class GlassNtfConstant {
  // 通知横幅距顶端位置
  public static readonly BANNER_TOP: number = 60;
  // 通知横幅宽度
  public static readonly BANNER_WIDTH: number = 1078;
  // 通知横幅高度
  public static readonly DEFAULT_BANNER_HEIGHT: number = 96;
  // 实况通知横幅宽度
  public static readonly LIVE_WIDTH: number = px2vp(720);
  // 实况通知横幅高度
  public static readonly LIVE_HEIGHT: number = px2vp(123);
  // 提示通知横幅宽度
  public static readonly HINT_WIDTH: number = px2vp(1078);
  // 提示通知横幅高度
  public static readonly HINT_HEIGHT: number = px2vp(96);
  // 普通通知横幅高度
  public static readonly NORMAL_HEIGHT: number = px2vp(96);
  // 普通通知横幅展开高度
  public static readonly EXPAND_HEIGHT: number = px2vp(265);
  // 普通通知横幅宽度
  public static readonly NORMAL_WIDTH: number = px2vp(1078);
  // 普通通知横幅展开内容宽度
  public static readonly EXPAND_CONTENT_WIDTH: number = px2vp(945);
  // 通知最多显示的按钮数量
  public static readonly BUTTON_MAX_SHOW_SIZE: number = 2;
  // 通知显示动效时长
  public static readonly APPEAR_TIME: number = 1000;
  // 通知隐藏动效时长
  public static readonly DISAPPEAR_TIME: number = 600;
  // 通知隐藏后状态栏延时显示时长
  public static readonly STATUS_APPEAR_TIME: number = 500;
  // 普通通知自动隐藏时间
  public static readonly CANCEL_DEFAULT_TIME: number = 5000;
  public static readonly BANNER_CURVE: curves.ICurve = curves.cubicBezierCurve(0.4, 0.0, 0.4, 1.0);
  public static readonly blackAppList: string[] = [
    '',
    'com.ohos.huaweicast',
  ];
  public static readonly IMAGE_ICON_ID: string = '_image_app_icon';
  public static readonly PHONE_BUNDLE_NAME: string = 'com.ohos.callui';
  public static readonly MESSAGE_BUNDLE_NAME: string = 'com.ohos.mms';
  public static readonly BANNER_TRANSLATE_Y: number = -150;
  public static readonly BANNER_ANIMATE_DURATION: number = 330;
  public static readonly BANNER_ANIMATE_CURVE: curves.ICurve = curves.cubicBezierCurve(0.42, 0.00, 0.66, 1.00);
}

export function getBannerTransition(): TransitionEffect {
  return TransitionEffect.asymmetric(
    TransitionEffect.translate({
      y: GlassNtfConstant.BANNER_TRANSLATE_Y
    })
      .animation({
        duration: GlassNtfConstant.BANNER_ANIMATE_DURATION,
        curve: GlassNtfConstant.BANNER_ANIMATE_CURVE
      })
      .combine(TransitionEffect.OPACITY.animation({
        duration: GlassNtfConstant.BANNER_ANIMATE_DURATION,
        curve: GlassNtfConstant.BANNER_ANIMATE_CURVE
      })),
    TransitionEffect.translate({
      y: GlassNtfConstant.BANNER_TRANSLATE_Y
    })
      .animation({
        duration: GlassNtfConstant.BANNER_ANIMATE_DURATION,
        curve: GlassNtfConstant.BANNER_ANIMATE_CURVE
      })
      .combine(TransitionEffect.OPACITY.animation({
        duration: GlassNtfConstant.BANNER_ANIMATE_DURATION,
        curve: GlassNtfConstant.BANNER_ANIMATE_CURVE
      }))
  )
}