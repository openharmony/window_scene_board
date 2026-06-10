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
import type { IUpdatable } from '../../base/common/interface/IUpdatable';
import type { ImmersiveShowType } from '../common/ImmersiveConstants';
import type { IResult } from '../base/dataparse/IResult';
import { LiveViewData } from '../../liveview/data/LiveViewData';
import { ICapsuleData } from './ICapsuleData';
import { image } from '@kit.ImageKit';
import { DrawableDescriptor } from '@kit.ArkUI';

/**
 * 接口，组件UI绑定数据
 */
export interface IImmersiveData extends IResult, IUpdatable {
  /**
   * 是否显示沉浸卡片
   *
   * @returns boolean
   */
  shouldShowInImmersiveCard(): boolean;

  /**
   * 是否显示锁屏胶囊
   *
   * @returns boolean
   */
  shouldShowInCapsule(): boolean;

  /**
   * 是否是UIExtension类型通知
   *
   * @returns boolean
   */
  isUiExtensionCard(): boolean;

  /**
   * 新增显示场景
   *
   * @param showType 场景
   */
  addShowType(showType: ImmersiveShowType): void;

  /**
   * 删除显示场景
   *
   * @param showType 场景
   */
  deleteShowType(showType: ImmersiveShowType): void;

  /**
   * 设置是否隐藏通知内容
   */
  setNtfHide(isHideContent: boolean);

  /**
   * 设置当前应用是否处于应用锁保护状态
   *
   * @param isAppLocked 是否处于应用锁保护状态
   */
  setAppLocked(isAppLocked?: boolean);

  /**
   * 注入实况数据
   *
   * @param liveView 实况数据
   * @param forceRefresh 强制刷新
   */
  setLiveViewData(liveView: LiveViewData, forceRefresh?: boolean): void;

  /**
   * 获取胶囊数据
   *
   * @returns ImmersiveCapsuleData
   */
  getCapsuleData(): ICapsuleData;

  /**
   * 设置当前数据是否正在沉浸卡片显示
   *
   * @param isShowInCard 是否在显示
   */
  setShowInCard(isShowInCard: boolean): void;

  /**
   * 是否正在沉浸卡片显示中
   *
   * @returns
   */
  isShownInCard(): boolean;

  /**
   * 图标数据切换提醒回调
   */
  onAppIconChange(): void;

  /**
   * 应用名数据切换提醒回调
   */
  onUpdateAppName(appName: string): void;

  /**
   * 设置应用图标
   *
   * @param appIcon 图标
   * @param forceRefresh 是否强制刷新
   */
  setAppIcon(appIcon?: image.PixelMap | string | DrawableDescriptor, forceRefresh?: boolean): void;

  /**
   * 设置应用名称
   *
   * @param appName 应用名
   * @param forceRefresh 是否强制刷新
   */
  setAppName(appName?: string, forceRefresh?: boolean): void;
}