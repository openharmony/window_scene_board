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
import { CustomPromise } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { NormalNotification } from '../../model/NormalNotification';

export interface NotificationBannerStyle {
  itemWidth: number;
  containerWidth: number;
  bannerTransY: number;
  containerMarginTop: number;
  containerMarginBottom: number;
  containerMarginLeft: number;
  containerMarginRight: number;
}

export interface INotificationBannerVm {
  ntf: NormalNotification | undefined;
  /**
   * 横幅宽度
   */
  bannerWidth: number;

  /**
   * 横幅位移X
   */
  bannerTransX: number;

  /**
   * 横幅位移Y
   */
  bannerTransY: number;

  /**
   * 横幅缩放X
   */
  scaleX: number;

  /**
   * 横幅缩放Y
   */
  scaleY: number;

  margin: Margin;

  /**
   * 转场动效
   */
  headsUpTransitionEffect: TransitionEffect;

  /**
   * banner面板横幅样式
   */
  notificationBannerStyle: NotificationBannerStyle | undefined;

  /**
   * 容器宽度
   */
  containerWidth: number | undefined;

  /**
   * 容器宽度
   */
  containerHeight: number | undefined;

  /**
   * 容器位移Y
   */
  containerTranslateY: number | undefined;

  /**
   * 容器位移X
   */
  containerTranslateX: number | undefined;

  /**
   * 蒙层图标缩放
   */
  floatingLayerIconScale: number;

  /**
   * 容器裁剪
   */
  containerClip: boolean | undefined;

  /**
   * 容器缩放
   */
  containerScale: number;

  /**
   * 容器缩放
   */
  containerScaleOptions: ScaleOptions;

  /**
   * 窗口ID
   */
  persistentId: number;

  /**
   * 是否显示沉浸态卡片
   */
  isShowImmersive: boolean;

  /**
   * 是否沉浸态已展开
   */
  isImmersiveExpanded: boolean;

  /**
   * 是否隐藏横幅内容
   * @returns
   */
  isHiddenBannerContent: boolean;

  /**
   * 触摸promise
   */
  touchPromise?: CustomPromise<void>;

  /**
   * 形变promise
   */
  deformPromise?: CustomPromise<void>;

  /**
   * 是否中景窗态
   */
  isMidScene: boolean;

  /**
   * 创建
   */
  init(): void;

  /**
   * 销毁
   */
  destroy(): void;

  /**
   * 横幅组件销毁回调
   */
  onDisappear(): void;

  removeWatcher(): void;

  resetWatcher(): void;

  addWatcher(): void;

  /**
   * 设置顶部间距
   */
  setContainerMarginTop(): void;

  /**
   * 滑动删除横幅后续操作
   */
  onHideBanner(): void;

  /**
   * 点击横幅通知时隐藏横幅面板
   */
  releasePanel(): void;

  /**
   * 点击横幅
   */
  onClick(): void;

  /**
   * 触摸事件
   * @param event
   */
  onTouch: (event: TouchEvent) => void;

  /**
   * 清除出场/消失动画修改任务
   */
  clearChangeTransitionEffectJob(): void

  /**
   * 设置超时收起蒙版兜底计时任务
   */
  setHideMaskTimer(): void;

  /**
   * 横幅形变成悬浮窗开始时，固定顶部边距，避免蒙版受状态栏显隐影响发生位置错乱和跳变
   */
  getMarginTop(): number;

  /**
   * 刷新中景窗状态
   */
  refreshMidSceneState(): Promise<void>;
}