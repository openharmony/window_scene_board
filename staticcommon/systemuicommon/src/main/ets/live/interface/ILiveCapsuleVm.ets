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

import { image } from '@kit.ImageKit';
import { CustomPromise } from '@ohos/frameworkwrapper';
import { CapsuleShowType, LiveButtonModel } from '../model/LiveCommonModel';
import { LiveNotification } from '../model/LiveNotification';
import { LottieCapsuleViewNode } from '../view/LottieCapsuleView';

/**
 * 实况胶囊VM
 */
export interface ILiveCapsuleVm {
  /**
   * 胶囊经过布局计算后的显示类型,不影响UI
   */
  fixedShowType: CapsuleShowType;
  /**
   * 胶囊经过布局计算后的显示类型,影响UI
   */
  showType: CapsuleShowType;
  /**
   * 胶囊组件ID
   */
  componentId: string;
  /**
   * 胶囊当前宽度，单位vp
   */
  width: number;
  /**
   * 胶囊当前高度，单位vp
   */
  height: number;
  /**
   * 胶囊圆角宽度
   */
  capsuleCircleWidth: number;
  /**
   * 胶囊图标宽度
   */
  capsuleIconWidth:number;
  /**
   * 胶囊图标宽度（像素）保证同心圆完全居中
   */
  capsuleIconWidthPx: number;
  /**
   * 胶囊图标边距
   */
  capsulePadding: number;
  /**
   * 胶囊阴影高度
   */
  capsuleShadowHeight: number;
  /**
   * 胶囊阴影圆角
   */
  shadowBorderRadius: number;
  /**
   * 胶囊阴影裁切
   */
  shadowClipBorderRadius: number;
  /**
   * 胶囊阴影和外边缘的距离
   */
  distanceBetweenShadowAndOutside: number;
  /**
   * 胶囊经过计算后应该显示的宽度，单位vp
   */
  fixedWidth: number;
  /**
   * 胶囊经过计算后应该显示的横向偏移量
   */
  fixedOffsetX: number;
  /**
   * 胶囊主题颜色属性
   */
  contentColor: ResourceColor | undefined;
  /**
   * 胶囊背板底色
   * 用于动效过程中颜色变化
   */
  backgroundColor?: ResourceColor | undefined;
  /**
   * 胶囊容器的颜色，背板的颜色
   */
  containerColor: ResourceColor | undefined;
  /**
   * 胶囊透明度
   */
  opacity: number;
  /**
   * 胶囊按钮透明度，目前无场景使用胶囊按钮作为胶囊显示态，默认为1，受父组件透明度控制
   */
  buttonOpacity: number;
  /**
   * 胶囊模糊
   */
  blur: number;
  /**
   * 胶囊横向偏移量，单位vp
   */
  offsetX: number;
  /**
   * 胶囊纵向偏移量，单位vp
   */
  offsetY: number;
  /**
   * 胶囊横向缩放
   */
  scaleX: number;
  /**
   * 胶囊纵向缩放
   */
  scaleY: number;
  /**
   * 胶囊层级
   */
  zIndex?: number;
  /**
   * 胶囊图标
   */
  icon?: image.PixelMap | string;
  /**
   * 胶囊按钮
   */
  button?: LiveButtonModel;
  /**
   * 胶囊按钮图标
   */
  buttonIcon?: image.PixelMap;
  /**
   * 组件显示后的承诺
   */
  appearPromise: CustomPromise<void>;

  /**
   * 胶囊图标宽度
   */
  iconWidth: number;
  /**
   * 是否临时抢占、即时任务
   */
  isTempDisplay: boolean;
  /**
   * 是否显示右侧图标(UI)
   */
  isShowRightIcon: boolean;
  /**
   * 是否显示右侧图标（状态）
   */
  fixedIsShowRightIcon: boolean;
  /**
   * 右侧图标
   */
  rightIcon?: image.PixelMap;
  /**
   * 是否需要显示主副文本分隔符
   */
  isNeedSeparator: boolean;
  /**
   * 主副文本分隔符组件宽度
   */
  separatorWidth: number;
  /**
   * 是否单边堆叠两个图标
   */
  isStackIcons: boolean;
  /**
   * 单边堆叠图标偏移距离
   */
  stackIconMargin: number;
  /**
   * 胶囊是否有空间展示
   */
  isShow: boolean;

  /**
   * 胶囊是否展示过
   */
  isShowed: boolean;

  /**
   * 是否为抢占态显示
   */
  isRemindShow: boolean;

  /**
   * 胶囊是否显示
   */
  isVisible: boolean;

  /**
   * 是否待删除状态
   */
  isToDelete: boolean;

  /**
   * 胶囊宽度是否盖过时间
   */
  isOutOfTime: boolean;

  /**
   * 是否布局支持拓展内容显示
   */
  isLayoutSupportExtendShow: boolean;

  /**
   * 经过计算，新内容胶囊是否布局支持拓展内容显示
   */
  fixedIsLayoutSupportExtendShow: boolean;

  /**
   * 非挂孔圆饼
   */
  isCakeShow: boolean;

  /**
   * 是否展示进度条
   */
  isShowProgress?: boolean;

  /**
   * 胶囊是否显示应用图标
   */
  isShowCapsuleIcon?: boolean;

  /**
   * 胶囊内容透明度
   */
  contentOpacity: number;

  /**
   * 胶囊内容横向缩放
   */
  contentScaleX: number;

  /**
   * 胶囊内容纵向缩放
   */
  contentScaleY: number;

  /**
   * 关闭outline显示
   * 用于动效过程
   */
  disableOutline: boolean;

  /**
   * 存在主副文本时，两个跑马灯之间的间隔，左挂孔，两端挂孔，无孔场景的值都不一样
   */
  capsuleMarqueeSpace: number;

  /**
   * 主副文本及其间隔的宽度总和
   */
  totalTextWidth: number;

  /**
   * marquee是否运行
   * marquee仅在新增和更新时运行
   */
  shouldRunnMarquee: boolean;

  /**
   * 单端挂孔渐变底定制
   */
  linearGradientSingleEndColors: Array<[ResourceColor, number]>;
  linearGradientSingleEndWidth: number;

  /**
   * 双端挂孔渐变底定制
   */
  linearGradientDoubleEndColors: Array<[ResourceColor, number]>;
  linearGradientDoubleEndWidth: number;

  capsuleTextMarginStart: number;

  capsuleTextMarginEnd: number;

  faceLockLottieNode?: LottieCapsuleViewNode;

  /**
   * 单个胶囊的高度（区分挂孔，圆饼和阴影）
   */
  capsuleHeight: number;

  /**
   * 胶囊点击事件
   */
  onClick(): void;

  /**
   * 胶囊按钮点击事件
   */
  onClickButton(): void;

  /**
   * 获取胶囊尺寸信息
   */
  getRect(): RectResult;

  /**
   * 进度类非挂孔胶囊
   */
  setCakeShowVal(): void;

  /**
   * 根据类型更新底板渐变
   */
  updateLinearGradient(): void;

  /**
   * 判断是否为显示赛事比分场景
   */
  isScoreScene(live?: LiveNotification): boolean;

  setCapsuleOpacity(needShow?: boolean): void;
}
