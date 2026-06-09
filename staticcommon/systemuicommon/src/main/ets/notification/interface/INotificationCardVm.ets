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
import { NotificationBase } from '../../model/NotificationBase';

/**
 * 通知卡片ViewModel
 *
 * @since 2024-11-25
 */
export interface INotificationCardVm {
  ntf: NotificationBase;
  /**
   * 是否正在一键删除动效过程中
   */
  isInClearAllAnim: boolean;
  /**
   * 是否正在下拉动效过程中
   */
  isInAppearAnim: boolean;
  /**
   * 组件ID
   */
  componentId: string;

  /**
   * 卡片内容组件ID
   */
  contentId: string;

  /**
   * 是否需要设置横滑手势
   */
  needGesture: boolean;

  /**
   * 滑动缩放
   */
  scale: number;

  /**
   * 按压缩放
   */
  itemClickScale: number;

  /**
   * 缩放Y轴中心
   */
  scaleCenterY: string | number;

  /**
   * 获取卡片宽度（考虑悬浮窗）
   */
  cardWidth: number | string;

  /**
   * 透明度
   */
  opacity: number;

  /**
   * Y轴偏移量
   */
  translateY: number;

  /**
   * 容器裁切
   */
  containerClip: boolean | RectAttribute | undefined;

  /**
   * 内容裁切
   */
  contentClipParam: boolean | RectAttribute;

  /**
   * 卡片内容对齐方式
   */
  align: Alignment;

  /**
   * 定位信息
   */
  position?: Position;

  /**
   * zIndex
   */
  zIndex: number;

  /**
   * 卡片容器尺寸
   */
  containerSize?: SizeOptions;

  /**
   * 卡片内容尺寸
   */
  contentSize: SizeOptions;

  /**
   * 卡片内容缩放度
   */
  cardContentScale?: ScaleOptions | undefined;

  /**
   * 卡片背景颜色
   */
  cardBgColor?: ResourceColor;

  /**
   * 卡片提亮参数
   */
  cardBgBrightness?: BrightnessOptions | undefined;

  /**
   * 卡片背景模糊
   */
  cardBgBlurStyle?: BlurStyle;

  /**
   * 卡片模糊参数
   */
  cardBgEffect?: BackgroundEffectOptions;

  /**
   * 卡片阴影
   */
  shadow?: ShadowStyle;

  /**
   * 通知卡片是否可以操作
   */
  cardEnable: boolean;

  /**
   * 卡片高度
   */
  height: number;

  /**
   * 卡片背景高度
   */
  cardBgHeight?: number | string | undefined;

  /**
   * 是否正在触摸通知卡片
   */
  isTouching?: boolean;

  /**
   * 是否隐藏卡片背景
   */
  isCardBgHide?: boolean;

  /**
   * 播控中心图标点击事件回调
   */
  onMediaCenterIconClick?: () => void;

  /**
   * 无障碍Description
   */
  accessibilityDescription?: string;

  /**
   * 是否是隐私卡片
   */
  isPrivacy: boolean

  /**
   * 标题颜色
   */
  titleFontColor: ResourceColor | undefined;

  /**
   * 文本颜色
   */
  textFontColor: ResourceColor | undefined;

  /**
   * 图标的透明度
   */
  iconAlpha?: number | undefined;

  /**
   * 图标的背板可见性
   */
  iconBgVisible?: Visibility;

  /**
   * 图标的背板颜色
   */
  iconBgColor?: ResourceColor | undefined;

  /**
   * 覆盖在右上角的图标的透明度
   */
  topIconAlpha?: number | undefined;

  /**
   * 覆盖在右上角的图标背板可见性
   */
  topBgVisible?: Visibility | undefined;

  /**
   * 覆盖在右上角的图标背板颜色
   */
  topBgColor?: ResourceColor | undefined;

  /**
   * 内容文本字体前景提亮参数
   */
  fontFgBrightness?: BrightnessOptions | undefined;

  // 置顶文本颜色
  pinTopTextColor?: ResourceColor | undefined;

  // 置顶文本前景提亮
  pinTopFgBrightness?: BrightnessOptions | undefined;

  /**
   *是否是成组场景
   */
  isSaveGroupNtf: boolean;

  /**
   * 是否显示组通知
   */
  showGroup: boolean;

  /**
   * 普通通知时间文本可见性
   */
  ntfTimeVisibility?: Visibility | undefined;

  /**
   * 通知卡片是否启用useEffect
   */
  isUseEffect: boolean;

  /**
   * 尺寸变化事件
   * @param _
   * @param size
   */
  onSizeChange: (_: SizeOptions, size: SizeOptions) => void;

  /**
   * 条目位置变化事件
   *
   * @param _
   * @param area
   */
  onAreaChange?: (_: Area, area: Area) => void;

  /**
   * 重置ListItem的属性
   */
  reset(): void;

  /**
   * 知卡片滑动堆叠
   *
   * @param scale 缩放
   * @param opacity 透明度
   * @param translateY 位移
   * @param zIndex zIndex
   */
  scrollListItem(scale: number, opacity: number, translateY: number, zIndex?: number): void;

  /**
   * 一键删除动效
   *
   * @param scale 缩放值
   * @param opacity 透明度
   * @param translateY 位移
   * @param contentClipParam 容器裁剪参数
   */
  clearAllAnimation(scale?: number, opacity?: number, translateY?: number): void;

  /**
   * 通知item依次出场动效
   * @param scale 缩放值
   * @param opacity 透明度
   * @param translateY 位移
   */
  itemAppearAnimation(scale?: number, opacity?: number, translateY?: number): void;

  /**
   * 是否为折叠态的更多通知
   *
   * @returns 判断结果
   */
  isMoreBrief(): boolean

  /**
   * 更新通知卡片转场动效
   *
   * @param animation 转场动效
   */
  updateTransitionAnimation(animation: TransitionEffect): void;

  /**
   * 获取通知卡片转场动效
   *
   * @returns 动效参数
   */
  getTransitionAnimation(): TransitionEffect;

  /**
   * 通知圆角裁切
   * @param clipHeight 裁切高度
   * @param clipOffset 裁切偏移量
   */
  setItemClipParam(clipHeight?: number, clipOffset?: number): void;

  /**
   * 卡片点击事件
   *
   * @param ntf 被点击的通知信息
   */
  onClick(ntf?: NotificationBase): void;

  /**
   * 卡片触摸事件
   *
   * @param event 触摸事件
   */
  onTouch(event: TouchEvent): void;

  /**
   * 删除通知前将卡片高度设置为0
   */
  changeNtfHeight2Zero(): void;

  /**
   * 删除链式补位动效
   *
   * @param translateY 位移值
   * @param scale 缩放
   * @param opacity 透明度
   */
  deleteChainAnimation(translateY: number, scale?: number, opacity?: number): void

  /**
   * 卡片scroll划出后设置为透明，避免后续出现时处理堆叠裁切导致显示跳变
   */
  setItemScrollHide(): void;

  /**
   * 获取卡片背景颜色
   */
  getCardBgColor(): ResourceColor | undefined;

  /**
   * 根据组件Id获取组件一镜到底动效Id，用于组通知header和单通知共用组件一镜到底场景
   *
   * @param componentId 组件类型Id
   * @return componentGeometryId 组件用于geometryTransition一镜到底动效的Id
   */
  getComponentGeometryId(componentId: string): string;

  /**
   * 判断手势拦截
   */
  onGestureJudgeBegin(info: GestureInfo): GestureJudgeResult;

  /**
   * 获取更多通知zIndex
   * @param index
   * @returns
   */
  getMoreNtfZIndex(index: number): number;

  /**
   * 卡片出场重置ListItem部分属性，其他属性由出场动效赋值
   */
  itemAppearReset(): void;

  /**
   * 获取通知卡片无障碍主动聚焦组件Id
   *
   * @returns compId 主动聚焦的组件Id
   */
  getAccessibilityFocusId(): string;
}