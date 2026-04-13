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

export class FlashlightTipsConstants {
  /**
   * 打点包名
   */
  public static readonly PNAMEID: string = 'com.ohos.sceneboard';

  /**
   * 打点应用名
   */
  public static readonly PVERSIONID: string = 'sceneBoard';

  /**
   * 手电筒提示页打点事件
   */
  public static readonly LAUNCHER_FLASHLIGHT_TIPS_EVENT: string = 'LAUNCHER_FLASHLIGHT_TIPS_EVENT';

  /**
   * 进入手电筒提示页打点
   */
  public static readonly OPEN_FLASHLIGHT_TIPS_EVENT: number = 1;

  /**
   * 翻转手机打开手电筒打点
   */
  public static readonly OPEN_FLASHLIGHT_BY_FLIP_EVENT: number = 2;

  /**
   * 展开手机打开手电筒打点
   */
  public static readonly OPEN_FLASHLIGHT_BY_UNFOLD_EVENT: number = 3;

  /**
   * 点击电源键关闭手电筒打点
   */
  public static readonly CLOSE_FLASHLIGHT_BY_POWER_EVENT: number = 4;

  /**
   * 点击关闭按钮关闭手电筒打点
   */
  public static readonly CLOSE_FLASHLIGHT_BY_BUTTON_EVENT: number = 5;

  /**
   * 折叠手机关闭手电筒打点
   */
  public static readonly CLOSE_FLASHLIGHT_BY_FOLD_EVENT: number = 6;

  /**
   * 手机旋转角度
   */
  public static readonly ROTATION_THRESHOLD: number = 200;

  /**
   * 陀螺仪监听间隔 ns
   */
  public static readonly GYROSCOPE_INTERVAL: number = 10000000;

  /**
   * 打开手电筒状态值
   */
  public static readonly OPEN_FLASHLIGHT_VALUE: number = 1;

  /**
   * 关闭手电筒状态值
   */
  public static readonly CLOSE_FLASHLIGHT_VALUE: number = 0;

  /**
   * 退出延迟(播放完动效后退出)
   */
  public static readonly QUIT_ANIMATION_DELAY: number = 300;

  /**
   * 上滑退出手势阈值
   */
  public static readonly QUIT_GESTURE_THRESHOLD: number = 20;

  /**
   * 设置常亮的数值
   */
  public static readonly STEADY_ON_VALUE: number = -1;

  /**
   * 资源路径
   */
  public static readonly RESOURCE_PATH: string = '/sys_prod/etc/flipFlashlight';

  /**
   * 帧动画文件名称
   */
  public static readonly FILE_NAME_PREFIX: string = 'flip_flashlight_';

  /**
   * 文件分隔符
   */
  public static readonly FILE_SEPARATOR: string = '/';

  /**
   * 文件后缀名
   */
  public static readonly FILE_NAME_SUFFIX: string = '.png';

  /**
   * 帧动画间隔时间
   */
  public static readonly ANIMATION_DURATION: number = 33;

  /**
   * 帧动画播放完成后间隔时间(重复播放)
   */
  public static readonly ANIMATION_DURATION_END: number = 1000;

  /**
   * 侧滑事件场景类型
   */
  public static readonly SCENE_TYPE: string = 'FlashlightTips';

  /**
   * 退出按钮最大高度占屏幕的三分之一
   */
  public static readonly UI_QUIT_BUTTON_HEIGHT: string = '33.33%';

  /**
   * 退出按钮最宽度占屏幕的三分之一
   */
  public static readonly UI_QUIT_BUTTON_WIDTH: string = '33.33%';

  /**
   * 退出图标最大高度占按钮的43.75%
   */
  public static readonly UI_QUIT_IMAGE_HEIGHT: string = '43.75%';

  /**
   * 退出图标最大宽度占按钮的43.75%
   */
  public static readonly UI_QUIT_IMAGE_WIDTH: string = '43.75%';

  /**
   * 手电筒提示语最大宽度
   */
  public static readonly UI_TIPS_TEXT_MAX_WIDTH: string = '282vp';

  /**
   * 手电筒提示语字体大小
   */
  public static readonly UI_TIPS_TEXT_FONT_SIZE: number = 16;

  /**
   * 手电筒提示语距离屏幕顶部距离
   */
  public static readonly UI_TIPS_TEXT_MARGIN_TOP: number = 260;

  /**
   * 手电筒提示语切换动效开始点距离提示动画距离
   */
  public static readonly UI_TIPS_TEXT_MOTION_INITIAL_LOCATION: number = 28;

  /**
   * 提示动效重复时间点
   */
  public static readonly TEXT_VIDEO_REAPPEAR_TIME: number = 5194;

  /**
   * 切换提示语时间点
   */
  public static readonly TEXT_CHANGE_TIME: number = 1549;

  /**
   * 初始化资源所需时间
   */
  public static readonly TEXT_INIT_TIME: number = 20;

  /**
   * 提示语上移动效持续时间
   */
  public static readonly TEXT_MOTION_MOVE_TIME: number = 467;

  /**
   * 提示语透明度动效持续时间
   */
  public static readonly TEXT_MOTION_OPACITY_TIME: number = 367;

  /**
   * towText组件透明度改变延迟
   */
  public static readonly TWO_TEXT_OPACITY_DELAY: number = 100;

  /**
   * towText组件动效延迟
   */
  public static readonly TWO_TEXT_MOTION_DELAY: number = 33;

  /**
   * oneText组件动效上移距离
   */
  public static readonly ONE_TEXT_MOVE_DISTANCE: number = 24;

  /**
   * twoText组件动效上移距离
   */
  public static readonly TWO_TEXT_MOVE_DISTANCE: number = 28;

  /**
   * 打开手电筒提示页Event
   */
  public static readonly EXTERNAL_SCREEN_FLASHLIGHT_EVENT: string = 'ExternalScreenFlashlightEvent';

  /**
   * 关闭控制中心Event
   */
  public static readonly CLOSE_DROPDOWN_PANEL_EVENT: string = 'CloseDropdownPanelEvent';

  /**
   * 提示语与提示动画间距
   */
  public static readonly SPACING: number = 4;

  /**
   * 提示动画宽高
   */
  public static readonly ANIMATION_WIDTH_HEIGHT: number = 216;

  /**
   * 提示语容器偏移量
   */
  public static readonly TIPS_TEXT_CONTAINER_OFFSET: number = 30;
}
