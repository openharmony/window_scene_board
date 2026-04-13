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
import { StatusBarCapsulePosition } from '../model/StatusBarCapsulePosition';
import { LiveCapsuleLayoutInfo } from '../../live/model/LiveCommonModel';
/**
 * 状态栏
 */
export interface IStatusBarLayoutVm {
  /**
   * 标记状态栏界面是否初始化完成
   */
  statusBarViewLayoutEnable: boolean;

  /**
   * 实况胶囊的布局绝对位置
   */
  capsulePosition: StatusBarCapsulePosition;

  /**
   * 胶囊左侧X坐标,用于计算左侧剩余可放置图标区域宽度
   * 实况胶囊会通过translate，offset等变化改变该值
   */
  capsuleLeftX: number;

  /**
   * 胶囊右侧X坐标,用于计算右侧剩余可放置图标区域宽度
   */
  capsuleRightX: number;

  /**
   * 系统图标左侧位置，用于计算通知图标的可显示个数
   */
  systemIconLeftX: number

  /**
   * 状态栏左侧图标padding
   */
  statusBarPaddingLeft: number;

  /**
   * 状态栏顶部图标margin
   */
  statusBarMarginTop: number;

  /**
   * 系统图标之间的间隔
   */
  iconGap: number;

  /**
   * 是否有及时胶囊存在
   */
  isInstantShowing: boolean

  /**
   * 布局中可见的图标集合
   */
  layoutIsVisibleIcons: Set<string>

  /**
   * 临时不可见图标
   */
  iconTempHideInfo: Set<string>;

  /**
   * 挖孔避让图标
   */
  avoidIconName: string;

  /**
   * 挖孔避让外边距
   */
  avoidIconMargin: number;
  /**
   * 是否显示蒙层
   */
  isShowBlur: boolean;

  /**
   * 是否有胶囊显示
   */
  isExistCapsule: boolean;

  /**
   * 蒙层是否使用动画
   */
  enableBlurTransition: boolean;

  iconFilterRule: number;

  /**
   * 胶囊位置变化回调，需要刷新状态栏布局
   * @param left 胶囊区域左侧位置
   * @param right 胶囊区域右侧位置
   */
  onCapsulePositionChange(layoutInfo: LiveCapsuleLayoutInfo): void;

  /**
   * 状态栏图标基础布局计算，不考虑胶囊
   */
  recalculateBaseLayout(): void;

  /**
   * 状态栏图标基础布局计算，不考虑胶囊，不带动效
   */
  recalculateBaseLayoutWithoutAnimation(): void;

  /**
   * 以基础布局的结果为前提，考虑胶囊对布局的影响；
   */
  recalculateLayout(needAnimation: boolean): void;

  /**
   * 临时隐藏一会图标
   */
  hideIconForWhile(): void ;

  /**
   * 状态栏实布局信息刷新！
   */
  statusbarLayoutRefresh(): void;

  updateClockWidth(normalWidth: number, extrudeWidth: number): void;

  /**
   * 语言切换时状态栏布局变化，非对称挖孔需重新触发布局计算。
   */
  onLanguageChange(): void;

  init(): void;

  onDropdownShowChange(): void;

}