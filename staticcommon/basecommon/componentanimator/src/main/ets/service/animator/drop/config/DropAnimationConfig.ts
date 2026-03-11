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
import { DragConstants } from '@ohos/commonconstants';

/**
 * 落位动效的场景，用于划分落位动效控件，不同场景的控件在不同的窗口上加载
 */
export enum DropAnimationScene {
  /**
   * 桌面场景的落位动效
   */
  SCENE_DESKTOP = 1,

  /**
   * 锁屏场景的落位动效
   */
  SCENE_SCREEN_LOCK = 2,

  /**
   * 多选场景
   */
  SCENE_MULTI_SELECT = 3,
}

/**
 * 落位动效的终点位置，每个落位动效场景可以对应多种终点位置，不同终点位置的落位动效会被不同的动作取消
 */
export enum DropAnimationDestination {
  /**
   * 落在桌面上
   */
  DESKTOP = 1,

  /**
   * 落在dock栏
   */
  DOCK = 2,

  /**
   * 落在展开的文件夹
   */
  OPEN_FOLDER = 3,

  /**
   * 图标汇聚
   */
  MULTI_SELECT = 4,

  /**
   * 分区文件夹
   */
  REGION_FOLDER = 5
}

/**
 * 落位动效取消的原因，由用户操作触发
 */
export enum DropAnimationCancelReason {
  /**
   * 触摸桌面元素
   */
  TOUCH_DESKTOP_ITEM = 1,

  /**
   * 滑动桌面翻页
   */
  SWIPE_DESKTOP = 2,

  /**
   * 滑动文件夹翻页
   */
  SWIPE_FOLDER = 3,

  /**
   * 关闭文件夹
   */
  CLOSE_FOLDER = 4,

  /**
   * 上滑底部导航栏
   */
  SWIPE_NAV_BAR = 5,

  /**
   * 进入退出编辑模式
   */
  EDIT_MODE_CHANGE = 6,

  /**
   * 多选汇聚过程中移动
   */
  GATHER_MOVE = 6,

  /**
   * 屏幕旋转
   */
  SCREEN_ROTATE = 7,

  /**
   * 打开卡片中心
   */
  OPEN_FORM_CENTER = 8,

  /**
   * 分区文件夹滚动
   */
  SCROLL_REGION_FOLDER = 9
}

/**
 * 落位动效相关的规则配置
 */
export class DropAnimationConfig {
  private static targetConfigMap: Map<DropAnimationDestination, DropAnimationScene> = new Map();
  private static cancelConfigMap: Map<DropAnimationDestination, Set<DropAnimationCancelReason>> = new Map();
  private static scaleFactorMap: Map<DropAnimationScene, number> = new Map();

  static {
    this.addTargetConfig(DropAnimationScene.SCENE_DESKTOP, DropAnimationDestination.DESKTOP);
    this.addTargetConfig(DropAnimationScene.SCENE_DESKTOP, DropAnimationDestination.DOCK);
    this.addTargetConfig(DropAnimationScene.SCENE_DESKTOP, DropAnimationDestination.OPEN_FOLDER);
    this.addTargetConfig(DropAnimationScene.SCENE_DESKTOP, DropAnimationDestination.REGION_FOLDER);
    this.addTargetConfig(DropAnimationScene.SCENE_MULTI_SELECT, DropAnimationDestination.MULTI_SELECT);

    this.addCancelConfig(DropAnimationDestination.DESKTOP, DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
    this.addCancelConfig(DropAnimationDestination.DESKTOP, DropAnimationCancelReason.SWIPE_DESKTOP);
    this.addCancelConfig(DropAnimationDestination.DESKTOP, DropAnimationCancelReason.SWIPE_NAV_BAR);
    this.addCancelConfig(DropAnimationDestination.DESKTOP, DropAnimationCancelReason.EDIT_MODE_CHANGE);
    this.addCancelConfig(DropAnimationDestination.DESKTOP, DropAnimationCancelReason.SCREEN_ROTATE);
    this.addCancelConfig(DropAnimationDestination.DESKTOP, DropAnimationCancelReason.OPEN_FORM_CENTER);
    this.addCancelConfig(DropAnimationDestination.DOCK, DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
    this.addCancelConfig(DropAnimationDestination.DOCK, DropAnimationCancelReason.SWIPE_NAV_BAR);
    this.addCancelConfig(DropAnimationDestination.DOCK, DropAnimationCancelReason.EDIT_MODE_CHANGE);
    this.addCancelConfig(DropAnimationDestination.OPEN_FOLDER, DropAnimationCancelReason.SWIPE_FOLDER);
    this.addCancelConfig(DropAnimationDestination.OPEN_FOLDER, DropAnimationCancelReason.CLOSE_FOLDER);
    this.addCancelConfig(DropAnimationDestination.OPEN_FOLDER, DropAnimationCancelReason.SWIPE_NAV_BAR);
    this.addCancelConfig(DropAnimationDestination.MULTI_SELECT, DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
    this.addCancelConfig(DropAnimationDestination.MULTI_SELECT, DropAnimationCancelReason.SWIPE_DESKTOP);
    this.addCancelConfig(DropAnimationDestination.MULTI_SELECT, DropAnimationCancelReason.GATHER_MOVE);
    this.addCancelConfig(DropAnimationDestination.REGION_FOLDER, DropAnimationCancelReason.SCROLL_REGION_FOLDER);

    this.addScaleFactorConfig(DropAnimationScene.SCENE_DESKTOP, DragConstants.DROP_START_SCALE);
    this.addScaleFactorConfig(DropAnimationScene.SCENE_SCREEN_LOCK, DragConstants.DROP_START_SCALE);
    this.addScaleFactorConfig(DropAnimationScene.SCENE_MULTI_SELECT, 1);
  }

  private static addTargetConfig(scene: DropAnimationScene, target: DropAnimationDestination): void {
    this.targetConfigMap.set(target, scene);
  }

  private static addCancelConfig(target: DropAnimationDestination, reason: DropAnimationCancelReason): void {
    let reasons = this.cancelConfigMap.get(target);
    if (reasons == null) {
      reasons = new Set();
      this.cancelConfigMap.set(target, reasons);
    }
    reasons.add(reason);
  }

  private static addScaleFactorConfig(scene: DropAnimationScene, factor: number): void {
    this.scaleFactorMap.set(scene, factor);
  }

  public static getScaleFactorByScene(scene: DropAnimationScene): number {
    return this.scaleFactorMap.get(scene) ?? DragConstants.DROP_START_SCALE;
  }

  /**
   * 获取落位动效终点位置对应的场景
   *
   * @param target 落位动效终点位置
   * @returns 落位动效场景
   */
  public static getDropAnimationScene(target: DropAnimationDestination): DropAnimationScene {
    return this.targetConfigMap.get(target) ?? 0;
  }

  /**
   * 是否可以取消落位动效
   *
   * @param target 落位动效落点位置
   * @param reason 落位动效取消原因
   * @returns 是否可以取消落位动效
   */
  public static canCancel(target: DropAnimationDestination, reason: DropAnimationCancelReason): boolean {
    let reasons = this.cancelConfigMap.get(target);
    if (reasons == null) {
      return false;
    }
    return reasons.has(reason);
  }
}