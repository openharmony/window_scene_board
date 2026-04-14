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
import { LiveNotification } from '../model/LiveNotification';
import { StatusBarCapsulePosition } from '../../statusbar/model/StatusBarCapsulePosition';
import { NodeControllerManager } from '../../framenode/NodeControllerManager';
import { LiveCapsuleLayoutInfo, StatusBarChangeType } from '../model/LiveCommonModel';

export interface CapsuleTransferParam {
  /**
   * 融球动效执行时长，通常情况下不用指定，此时用融球VM中的默认值
   * 状态栏显隐场景，胶囊不执行动效，为保证融球状态与胶囊状态一致，需将融球动效时长指定为0。
   */
  metaBallToggleDuration?: number
  /**
   * 融球是否向上形变
   */
  isUpwards?: boolean;

  /**
   * 胶囊伸展是是否需要扫光
   */
  isNeedLight?: boolean;

  /**
   * 执行setCapsuleTransferState和expandCapsuleList函数的时延，若未指定，则使用animVm中指定的时延
   */
  delay?: number;

  /**
   * 是否是更新胶囊信息
   */
  isUpdateImmediately?: boolean;

  /**
   * 是否只走透明度变化动效。
   * 无孔场景下拉，胶囊无需缩至锚点处，只做透明度显隐变化
   */
  onlyChangeOpacity?: boolean;
  /**
   * 是否需要动效
   */
  needAnimation?: boolean;

  /**
   * 是否即时类
   */
  isInstant?: boolean;
}

export type CapsulePositionChangeCallback = (layoutInfo: LiveCapsuleLayoutInfo) => void;

export type StatusBarChangeCallback = (type?: StatusBarChangeType) => Promise<void>;

/**
 * 实况胶囊列表VM
 */
export interface ILiveCapsuleListVm {
  /**
   * 实况列表
   */
  liveList: LiveNotification[];

  /**
   * 胶囊位置信息
   */
  position: StatusBarCapsulePosition;

  /**
   * 实况胶囊列表节点管理
   */
  viewManager: NodeControllerManager;

  /**
   * 状态栏动效回调
   */ 
  statusBarChangeCallback?: StatusBarChangeCallback;

  /**
   * 是否在即时实况展示时点击胶囊展开卡片，打断即时实况展示
   */
  isInterruptInstantBanner: boolean;

  /**
   * 阴影的背景色
   */
  shadowColor: string;

  /**
   * 即将进入应用，通过点击横幅或卡片
   */
  isToEnterAppByClickCard: boolean;
  /**
   * 即将进入应用，通过点击胶囊
   */
  isToEnterAppByClickCapsule: boolean;

  /**
   * 即将进入应用名称
   */
  enterApplicationName: string | undefined;

  /**
   * 胶囊动效计数，不为0则胶囊处于动效中
   */
  capsuleAnimationCount: number;

  isShowCapsule: boolean;

  /**
   * 离屏渲染绘制后是否重复绘制缓存，解决外屏胶囊图片AOD显示偏色问题
   */
  isIconFreeze: boolean;

  /**
   * 实况胶囊列表初始化
   * @param position 位置信息
   * @param positionChangeCallback 位置变化回调
   */
  init(position: StatusBarCapsulePosition, positionChangeCallback: CapsulePositionChangeCallback,
    statusBarChangeCallback: StatusBarChangeCallback): void;

  /**
   * 初始化实况胶囊列表
   * @param liveList
   */
  initLiveList(liveList: LiveNotification[]): Promise<void>;

  /**
   * 新增实况胶囊列表
   */
  addLive(live: LiveNotification): Promise<void>;

  /**
   * 定时器变化触发胶囊宽度的更新
   * @param uid 定时器的uid
   * @returns
   */
  updateLiveByTimer(uid: string): Promise<void>;

  /**
   * 远端更新实况胶囊，是由业务方触发的更新，需要做一些更新动效
   */
  remoteUpdateLive(live: LiveNotification): Promise<void>;

  /**
   * 本地更新实况胶囊列表，是由环境变化场景触发的更新（如主题切换、深浅色切换、语言切换等），不需要做动效
   */
  localUpdateLiveList(liveList: LiveNotification[]): Promise<void>;

  /**
   * 删除实况胶囊列表
   */
  removeLiveList(liveList: LiveNotification[]): Promise<void>;

  /**
   * 带普通动效更新布局，在仅更新胶囊宽度等场景使用
   * @param live
   * @returns
   */
  animateToLayoutViewForUpdate(live: LiveNotification): Promise<void>;

  /**
   * 计算布局并更新列表视图
   * 根据capsuleTransferParam控制更新过程中的差异点
   * 如不提供, 则使用默认值
   */
  toggleCapsuleList(capsuleTransferParam?: CapsuleTransferParam): Promise<void>;

  /**
   * 挖孔信息变化回调，涉及融球上下树
   */
  onCutoutChange(): void;

  /**
   * 胶囊布局刷新
   */
  capsuleLayoutRefresh(): void;

  /**
   * 显示胶囊数量
   * @param isCountCapsuleHidden 需要统计因转换到其他状态而隐藏的胶囊数量，如展开卡片或下拉双中心状态
   * 例如有3个进度类胶囊，在展开卡片场景下，isCountCapsuleHidden为false时，计算数量为0，为true时，计算数量为3
   * @returns 显示胶囊数量
   */
  getShowCapsuleListNum(isCountCapsuleHidden?: boolean): number;

  onDropdownShowChange(): void;
}
