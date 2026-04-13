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
import curves from '@ohos.curves';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DragConstants } from '@ohos/commonconstants';
import { DropAnimationScene } from '@ohos/componentanimator';
import { launcherStatusUtil } from '@ohos/windowscene/src/main/ets/TsIndex';
import { CommonConstants, StyleConstants } from '../../TsIndex';

const TAG: string = 'MultiSelectStyleConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 多选拖拽 样式配置
 */
export class MultiSelectStyleConfig {
  /**
   * 多选框大小
   */
  public static readonly CHECKBOX_SIZE: number = 12;

  /**
   * 多选框突出应用图标和小文件夹的的距离
   */
  public static readonly CHECKBOX_APP_GAP: number = 3;

  /**
   * 多选框突出大文件夹的距离
   */
  public static readonly CHECKBOX_FOLDER_GAP: number = 1;

  /**
   * 多选汇聚关闭文件夹延迟
   */
  public static readonly CLOSE_FOLDER_DELAY = 50;

  /**
   * 汇聚动画时长
   */
  public static readonly GATHER_DURATION: number = 400;

  /**
   * 新形态小外屏汇聚动画时长
   */
  public static readonly OUTER_GATHER_DURATION: number = 300;

  /**
   * 汇聚后旋转延时
   */
  public static readonly ROTATE_DELAY: number = 16.67;

  /**
   * 汇聚后旋转动画时长
   */
  public static readonly ROTATE_DURATION: number = 250;

  /**
   * 汇聚后旋转角度
   */
  public static readonly ROTATE_ANGLES: number = 8;

  /**
   * 汇聚动效曲线
   */
  public static readonly GATHER_ANIMATE_CURVE: curves.ICurve = curves.cubicBezierCurve(0.2, 0, 0.2, 1);

  /**
   * 汇聚动效中 缩放，透明，旋转的曲线
   */
  public static readonly GATHER_ANIMATE_SCALE_CURVE: curves.ICurve = curves.cubicBezierCurve(0, 0, 1, 1);

  /**
   * 汇聚后第一元素的不透明度 同步arkUI ux规格
   */
  public static readonly FIRST_ICON_OPACITY: number = 1;

  /**
   * 汇聚后第二元素的不透明度
   */
  public static readonly SECOND_ICON_OPACITY: number = 0.6;

  /**
   * 汇聚后第三元素的不透明度
   */
  public static readonly THIRD_ICON_OPACITY: number = 0.3;

  /**
   * 拖拽框架支持的最大图标数量
   */
  public static readonly MAX_DRAG_ITEM_COUNT: number = 3;

  /**
   * 用于实现动效的场景
   */
  public static readonly ANIMATION_SCENE: DropAnimationScene = DropAnimationScene.SCENE_MULTI_SELECT;

  /**
   * 图标落位间隔时间
   */
  public static readonly DROP_ANIMATION_DELAY: number = 50;

  /** 长按触发预加载时长 */
  public static readonly LONG_PRESS_TIME_OF_PRE_GATHER: number = 300;

  /** 长按触发多选时长 */
  public static readonly LONG_PRESS_TIME_OF_GATHER: number = 400;

  /** 汇聚过程中多选框消失动效时长 ms*/
  public static readonly HIDE_CHECKBOX_DURING_GATHER_ANIMATE_DURATION: number = 150;

  /** 汇聚过程中手指移动取消动效的阈值 vp */
  public static readonly MOVE_THRESHOLD_DURING_GATHER_ANIMATE: number = 10;

  /** 汇聚动效后保持跟手效果，等待dragController触发的时长 */
  public static readonly WAIT_DRAG_CONTROLLER_DURATION: number = 100;

  private static _desktopIconSize: number = StyleConstants.DEFAULT_APP_ICON_SIZE_WIDTH;

  /** 获取桌面图标大小 */
  public static get DESKTOP_ICON_SIZE(): number {
    return this._desktopIconSize;
  }

  /** 设置桌面图标大小 */
  public static set DESKTOP_ICON_SIZE(val: number) {
    if (val !== this._desktopIconSize) {
      log.showInfo(`update desktop_icon_size ${val}`);
      this._desktopIconSize = val;
    }
  }

  private static _desktopIconRadius: number = CommonConstants.DEFAULT_ICON_RADIUS;

  /** 获取桌面图标圆角 */
  public static get DESKTOP_ICON_RADIUS(): number {
    return this._desktopIconRadius;
  }

  /** 设置桌面图标圆角 */
  public static set DESKTOP_ICON_RADIUS(val: number) {
    if (val !== this._desktopIconRadius) {
      log.showInfo(`update desktop_icon_radius ${val}`);
      this._desktopIconRadius = val;
    }
  }

  /** 动效组件图标模式缩放系数 */
  public static readonly DEFAULT_ANIMATE_ICON_SCALE_FACTOR: number = 1;

  public static readonly DRAG_ANIMATE_ICON_SCALE_FACTOR: number = DragConstants.DROP_START_SCALE;

  public static getGatherDuration(): number {
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      return MultiSelectStyleConfig.OUTER_GATHER_DURATION;
    }
    return MultiSelectStyleConfig.GATHER_DURATION;
  }
}