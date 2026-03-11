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

/**
 * 提取overlay卡片数据信息父类，解除对systemuicommon依赖
 */
export class OverlayCardInterface {
  /**
   * 启动应用包名
   */
  startBundleName: string;

  /**
   * 是否需要显示overlay组件
   * 1. 通过截图方式实现的一镜到底需要在窗口中显示overlay组件，即显示截图内容
   * 2. 通知中心通过zIndex实现的一镜到底，不需要显示overlay组件
   */
  isShowOverlayComponent: boolean = true;
}

/**
 * 定义overlay卡片动效属性状态父类，解除对systemuicommon依赖
 */
export class OverlayCardStateInterface {
}

/**
 * overlay卡片动效配置，用于scene容器中管理overlay卡片属性
 */
@Observed
export class OverlayCardTransition {
  /**
   * overlay卡片组件配置信息
   */
  overlayCardInfo: OverlayCardInterface;

  /**
   * overlay卡片组件动效属性状态
   */
  overlayCardState: OverlayCardStateInterface;
}