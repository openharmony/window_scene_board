/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import { CommonConstants } from '@ohos/launchercommon';

export class FormStackConstants {

  /**
   * 第一张卡片露出部分尺寸
   */
  public static readonly PRE_SHOW_SIZE: number = 24;

  /**
   * 默认最多显示卡片个数，不包括最后显示一小部分的卡片
   */
  public static readonly DEFAULT_SHOW_COUNT: number = 6;

  /**
   * 中间部分卡片显示尺寸相对卡片高度占比最小0.5
   */
  public static readonly SHOW_SIZE_MIN_RATIO: number = 0.5;

  /**
   * 滑动最小移动1个像素才处理
   */
  public static readonly MIN_MOVE_DISTANCE: number = 1;

  public static readonly DEFAULT_FORM_OPACITY: number = 0.7;

  public static readonly FORM_DELTA_DEFAULT_ROTATION_X: number = -6;

  public static readonly FORM_FIRST_DEFAULT_ROTATION_X: number = -10;

  public static readonly RIGHT_ANGLE_ROTATION: number = 90;

  /**
   * 堆叠在最底层的卡片初始alpha值
   */
  public static readonly PRE_FORM_CARD_ALPHA: number = 0.7;

  /**
   * 中间部分卡片显示尺寸相对卡片高度占比最大0.8
   */
  public static readonly SHOW_SIZE_MAX_RATIO: number = 0.8;

  public static readonly HEIGHT_DIVISION: number = 2;

  public static readonly SHOW_MAX_RATIO_OF_1X2_FORM: number = 1;

  /**
   * 外屏卡片堆叠展开卡片占比
   */
  public static readonly OUTER_SHOW_RATIO_OF_1X2_FORM: number = 1;

  public static readonly OUTER_SHOW_RATIO_OF_2X2_FORM: number = 0.5;

  public static readonly OUTER_SHOW_RATIO_OF_2X4_FORM: number = 0.8;

  public static readonly OUTER_SHOW_RATIO_OF_4X4_FORM: number = 0.2;
  /**
   * 开始堆叠卡片的初始缩放值
   */
  public static readonly FIRST_STACK_FORM_SCALE: number = 0.9;

  /**
   * 当编辑卡片滑动到边界后，相邻卡片之前的位移衰减百分比
   */
  public static readonly EDIT_FORM_TRANS_DAMPING_FACTOR: number = 0.1;

  /**
   * 滑动时如果超出边界后的阻尼因子：卡片高度的倍数
   */
  public static readonly MOVE_DAMPING_FACTOR: number = 2.0;

  /**
   * 形成堆叠时候，顶部卡片身份标识
   */
  public static readonly topDragCardImageIndex:number = 1;

  /**
   * 形成堆叠时候，第二张卡片身份标识
   */
  public static readonly secDragCardImageIndex:number = 2;

  /**
   * 第一张卡片x轴旋转角度：根据卡片大小（微、小、中、大）类型，取对应角度
   */
  public static readonly FORM_START_ROTATION_X: Map<number, number> = new Map<number, number>([
    [CommonConstants.CARD_DIMENSION_1x2, -10],
    [CommonConstants.CARD_DIMENSION_2x2, -10],
    [CommonConstants.CARD_DIMENSION_2x4, -8],
    [CommonConstants.CARD_DIMENSION_4x4, -5],
  ]);

  /**
   * 相邻卡片x轴旋转角度差：根据卡片大小（微、小、中、大）类型，取对应角度
   */
  public static readonly FORM_DELTA_ROTATION_X: Map<number, number> = new Map<number, number>([
    [CommonConstants.CARD_DIMENSION_1x2, -2],
    [CommonConstants.CARD_DIMENSION_2x2, -3],
    [CommonConstants.CARD_DIMENSION_2x4, -4],
    [CommonConstants.CARD_DIMENSION_4x4, -2],
  ]);

  public static readonly FORM_STACK_ITEM_MIN_LEN: number = 2;

  public static readonly DELETE_IMAGE_WIDTH: number = 40;

  public static readonly DELETE_IMAGE_HEIGHT: number = 40;

  public static readonly DELETE_IMAGE_MARGIN_LEFT_MIN: number = 63;

  public static readonly DELETE_IMAGE_MARGIN_TOP: number = 30;

  public static readonly FORM_STACK_OPEN_MARGIN_TOP: number = 39;

  public static readonly SWIPE_DOWN_FORM_STACK_PERCENT_SHOW: number = 0.6;

  public static readonly FORM_STACK_OPEN_RADIUS: number = 8;

  public static readonly SWIPE_DELETE_IMAGE_PERCENT_OF_FORM: number = 0.2;

  public static readonly FORM_STACK_OPEN_ROTATE_POINT_X: number = 1;

  public static readonly FORM_STACK_OPEN_ROTATE_POINT_CENTER_Y: number = -1;

  public static readonly FORM_STACK_HOT_AREA_MAX_MARGIN: number = 48;

  public static readonly FORM_STACK_OPEN_MIN_FORM_LEN: number = 2;

  public static readonly PRECISION_LEN: number = 2;

  public static readonly FORM_MOVE_DELETE_PERCENT: number = 0.6;

  public static readonly FORM_END_TRANSLATE_X_ADAPT_RATIO: number = 0.7;

  public static readonly FORM_MOVE_DELETE_DAMPING_PERCENT: number = 0.4;

  public static readonly DELETE_IMAGE_MOVE_SNOW_PERCENT: number = 0.2;

  public static readonly FORM_SHADOW_RADIUS: number = 40;

  public static readonly FORM_SHADOW_COLOR = 'rgba(5, 5, 5, 0.1)';

  public static readonly FORM_STACK_IMAGE_RADIUS: number = 16;

  public static readonly FORM_STACK_ID_PREFIX: string = 'FormStackView';

  public static readonly FORM_STACK_EXPAND_ID_PREFIX: string = 'FormStackExpandView';

  public static readonly FORM_CARD_DEFAULT_WIDTH: number = 153;

  public static readonly FORM_CARD_DEFAULT_HEIGHT: number = 153;

  public static readonly FORM_CARD_DIMENSION_4x4_SCALE: number = 0.7;

  public static readonly OUTER_FORM_CARD_DIMENSION_4x4_SCALE: number = 0.6;

  public static readonly DELETE_BUTTON_DISTANCE_FORM_STACK_RIGHT_MARGIN: number = 48;

  public static readonly DELETE_BUTTON_DISTANCE_FORM_SCREEN_RIGHT_MARGIN: number = 15;

  public static readonly FORM_STACK_MASK_OPACITY: number = 0.9;

  public static readonly COEFICIENT_DOUBLE: number = 2;

  public static readonly FLOAT_MIN_ACCURACY: number = 0.001;

  /**
   * 堆叠卡片下滑至展开时，手指与屏幕底部距离阈值，单位：mm
   */
  public static readonly SLIDE_TO_SCREEN_BOTTOM_DISTANCE = 15;

  /**
   * 堆叠卡片滑动至展开时的阈值距离，单位：mm
   */
  public static readonly slideThresholdDistance: Map<number, number> = new Map([
    [CommonConstants.CARD_DIMENSION_1x2, 30],
    [CommonConstants.CARD_DIMENSION_2x2, 40],
    [CommonConstants.CARD_DIMENSION_2x4, 40],
    [CommonConstants.CARD_DIMENSION_4x4, 50],
  ]);

  public static readonly outerSlideThresholdDistance: Map<number, number> = new Map([
    [CommonConstants.CARD_DIMENSION_1x2, 17],
    [CommonConstants.CARD_DIMENSION_2x2, 20],
    [CommonConstants.CARD_DIMENSION_2x4, 20],
    [CommonConstants.CARD_DIMENSION_4x4, 30],
  ]);

  /**
   * 堆叠卡片下滑成功时，首张卡片目标状态的竖向位移卡片阈值
   */
  public static readonly SLIDE_DOWN_SUCCESS_FIRST_FORM_TRANSLATE_RATIO = 0.9;

  /**
   * 堆叠卡片下滑跟手最大位移0.7倍卡片高度
   */
  public static readonly SLIDE_DOWN_MAX_TRANSLATE_Y_RATIO = 0.7;

  /**
   * 堆叠卡片下滑极限高度一半阈值时卡片透明度开始渐变
   */
  public static readonly SLIDE_DOWN_OPACITY_CHANGE_DISTANCE_RATIO = 0.35;

  public static readonly MAX_LEN_OF_DECIMAL_POINT: number = 3;

  /**
   * 堆叠卡片上滑手指最大位移距离阈值
   */
  public static readonly slideUpThresholdRatio: Map<number, number> = new Map([
    [CommonConstants.CARD_DIMENSION_1x2, 3],
    [CommonConstants.CARD_DIMENSION_2x2, 1.8],
    [CommonConstants.CARD_DIMENSION_2x4, 1.8],
    [CommonConstants.CARD_DIMENSION_4x4, 1.5],
  ]);

  /**
   * 上滑触发翻页跟手距离阈值
   */
  public static readonly SLIDE_UP_SUCCESS_FORM_TRANSLATE_THRESHOLD_RATIO = 0.35;

  /**
   * 响应滑动手势需要感知的最小距离阈值，单位：vp
   */
  public static readonly SLIDE_GESTURE_MIN_VALID_DISTANCE = 6;

  /**
   * 展开态删除按钮背景圆角大小
   */
  public static readonly EDIT_TRASH_BACKGROUND_COLOR_BORDER_RADIUS = 20;

  public static readonly EDIT_TRASH_HEAD_WIDTH = 20;

  public static readonly EDIT_TRASH_HEAD_HEIGHT = 5;

  public static readonly EDIT_TRASH_BODY_WIDTH = 16;

  public static readonly EDIT_TRASH_BODY_HEIGHT = 15;

  /**
   * 展开卡片侧滑垃圾桶盖最大旋转角度
   */
  public static readonly TRASH_HEAD_ANGLE_MAX = 15;

  /**
   * 展开卡片侧滑垃圾桶盖最大旋转角度
   */
  public static readonly TRASH_BODY_ANGLE_MAX = -15;

  /**
   * 堆叠卡片展开态下点按卡片Y轴位移，单位：vp
   */
  public static readonly EDIT_TOUCH_FEEDBACK_TRANSLATE_Y = 2;

  /**
   * 堆叠卡片展开态下点按反馈缩放系数
   */
  public static readonly EDIT_TOUCH_FEEDBACK_SCALE = 0.95;

  /**
   * 堆叠卡片展开侧滑时，上下卡片的避让距离
   */
  public static readonly EDIT_LATERAL_MOVE_AVOID_DISTANCE_THRESHOLD = 0.18;

  /**
   * 堆叠卡片展开侧滑时，顶部卡片补位的距离阈值
   */
  public static readonly EDIT_LATERAL_MOVE_TOP_FILLING_DISTANCE_THRESHOLD = 0.4;

  /**
   * 堆叠卡片展开侧滑时，底部卡片补位的距离阈值
   */
  public static readonly EDIT_LATERAL_MOVE_BOTTOM_FILLING_DISTANCE_THRESHOLD = 0.25;

  /**
   * 1*2、2*2卡片侧滑最大距离阈值
   */
  public static readonly EDIT_DIMENSION_SMALL_LATERAL_MOVE_MAX_THRESHOLD = 1.1;

  /**
   * 2*4、4*4卡片侧滑最大距离阈值
   */
  public static readonly EDIT_DIMENSION_LARGE_LATERAL_MOVE_MAX_THRESHOLD = 0.8;

  /**
   * 展开卡片滑动阻尼系数
   */
  public static readonly EDIT_PAN_GESTURE_DAMPING_RATIO = 1.848;

  /**
   * 卡片右侧滑阻尼最大位移
   */
  public static readonly EDIT_LATERAL_GESTURE_MOVE_RIGHT_MAX_DISTANCE = 80;

  /**
   * 展开列表滚动阻尼最大位移
   */
  public static readonly EDIT_LONGITUDINAL_GESTURE_MOVE_MAX_DISTANCE = 92;

  /**
   * 展开列表滚动阻尼最大角度变化
   */
  public static readonly EDIT_LONGITUDINAL_GESTURE_MOVE_MAX_ROTATE_ANGLE = 5;

  /**
   * 展开列表滚动阻尼末尾4张卡片位移映射比例
   */
  public static readonly editDampingSlideYRatio: number[] = [0.5, 0.75, 0.875, 0.9375];

  /**
   * 列表向下滚动离手后自动补位阈值高度
   */
  public static readonly EDIT_SLIDE_DOWN_AUTO_FILLING_HEIGHT_RATIO = 0.3;

  /**
   * 列表向上滚动离手后自动补位阈值高度
   */
  public static readonly EDIT_SLIDE_UP_AUTO_FILLING_HEIGHT_RATIO = 0.7;

  /**
   * 列表滑动手势速度阈值
   */
  public static readonly EDIT_LONGITUDINAL_SLIDE_SPEED_THRESHOLD = 600;

  public static readonly WAIT_FORM_SNAP_IMAGE_SHOW_MS = 50;

  public static readonly WAIT_FORM_STACK_REFRESH_MS = 500;

  public static readonly WAIT_FORM_REFRESH_MS = 500;

  /**
   * 堆叠卡片展开后显示的最大数量
   */
  public static readonly expandShowMaxCount: Map<number, number> = new Map([
    [CommonConstants.CARD_DIMENSION_1x2, 10],
    [CommonConstants.CARD_DIMENSION_2x2, 7],
    [CommonConstants.CARD_DIMENSION_2x4, 7],
    [CommonConstants.CARD_DIMENSION_4x4, 4],
  ]);

  /**
   * 长按：非触摸卡片压暗系数
   */
  public static readonly EDIT_OTHER_CARD_BRIGHTNESS_AFTER_LONG_PRESS = 0.85;

  /**
   * 长按：非触摸卡片放缩系数
   */
  public static readonly EDIT_OTHER_CARD_ZOOM_OUT_AFTER_LONG_PRESS = 0.98;

  /**
   * 长按：非触摸卡片还原避让距离的延时时间
   */
  public static readonly LONG_PRESS_CARD_AVOID_RESTORE_DELAY = 350;

  /**
   * 调序：拖拽卡片在热区停留时长阈值
   */
  public static readonly EDIT_DRAG_CARD_STAY_HOT_AREA_TIME_MS = 1000;

  /**
   * 调序：列表滚动自动触发换位的延时时间ms
   */
  public static readonly EDIT_DRAG_CARD_STAY_HOT_AREA_AUTO_SWAP_DELAY_MS = 250;

  /**
   * 调序：自动换位后刷新热区区域的延时时间ms
   */
  public static readonly EDIT_UPDATE_HOT_AREA_AFTER_DRAG_AUTO_SWAP_DELAY_MS = 1500;

  /**
   * 调序：列表滚动后自动触发换位的延时时间ms
   */
  public static readonly SCROLL_LIST_AUTO_SWAP_CARD_DELAY = 250;

  /**
   * 侧滑：删除剩一张卡片后触发落位的延时时间
   */
  public static readonly DELETE_LEFT_ONE_CARD_START_DROP_DELAY = 200;

  /**
   * 拖拽：落位截图的初始缩放系数
   */
  public static readonly DROP_START_SCALE: number = 1.05;

  /**
   * 拖拽/删除剩一张后通过桌面刷新的延时时间ms
   */
  public static readonly LEFT_ONE_CARD_NOTIFY_DESKTOP_UPDATE_DELAY = 250;

  /**
   * 拖拽：卡片落位动画时长
   */
  public static readonly DROP_CARD_DURATION = 250;

  /**
   * 卡片左滑阻尼最大距离
   */
  public static readonly editSlideXDampingDistance: Map<number, number[]> = new Map([
    [CommonConstants.CARD_DIMENSION_1x2, [160, 140]],
    [CommonConstants.CARD_DIMENSION_2x2, [160, 140]],
    [CommonConstants.CARD_DIMENSION_2x4, [800, 500]],
    [CommonConstants.CARD_DIMENSION_4x4, [600, 550]],
  ]);

  public static readonly EDIT_DROP_IMAGE_ID: string = FormStackConstants.FORM_STACK_EXPAND_ID_PREFIX + '_drop_snapshot';

  // 跟手向下滑动触发堆叠截图距离阈值
  public static readonly FORMSTACK_SNAP_IMAGE_SLIDE_RATIO = 0.3;

  // 堆叠展开态拖拽卡片调序动画时长
  public static readonly FORMSTACK_EXPAND_SWAP_CARD_DURATION = 200;

  // 堆叠菜单消失消息通知
  public static readonly EVENTHUB_FORMSTACK_MENU_DISAPPEAR = 'onFormStackMenuDisappear';

  // 外屏堆叠菜单消失消息通知
  public static readonly EVENTHUB_OUTER_FORMSTACK_MENU_DISAPPEAR = 'onOuterFormStackMenuDisappear';

  // 外屏堆叠菜单长按拖动结束通知
  public static readonly EVENTHUB_OUTER_FORMSTACK_MENU_DRAG_END = 'onOuterFormStackMenuDragEnd';

  // 外屏堆叠菜单长按拖动开始通知
  public static readonly EVENTHUB_OUTER_FORMSTACK_MENU_DRAG_START = 'onOuterFormStackMenuDragStart';

  // 堆叠卡片滑动切换卡片卡顿打点
  public static readonly SLIDE_TO_SWITCH_CARD_DOT = 'FORMSTACK_SWITCH_CARD';

  // 堆叠截图，当前主要是场景卡动效场景
  public static readonly FORM_STACK_SNAP_SHOW_MSG = 'formStackSnapShowView';

  // 上滑翻页雷达打点
  public static readonly FORMSTACK_SLIDE_UP = 'FORMSTACK_SLIDE_UP';

  // 下滑翻页雷达打点
  public static readonly FORMSTACK_SLIDE_DOWN = 'FORMSTACK_SLIDE_DOWN';

  // 滑动还原雷达打点
  public static readonly FORMSTACK_SLIDE_BACK = 'FORMSTACK_SLIDE_BACK';

  // 2*1堆叠卡片展开后，卡片之间的距离是8vp
  public static readonly DISTANCE_BETWEEN_FORM_AND_FORM = 8;

  public static readonly FORMSTACK_POS_ARRAY_LEN = 3;

  // 堆叠展开态长按隐藏删除图标时长: ms
  public static readonly FORMSTACK_EXPAND_HIDE_DEL_IMAGE_TIME = 450;

  // 堆叠卡片长按后触发截图并缓存时长: ms
  public static readonly FORMSTACK_LONG_PRESS_SNAP_IAMGE_TIME = 400;

  // 形成堆叠、加卡到堆叠后顶卡onload完成取消截图遮罩延时：ms
  public static readonly FORMSTACK_ONLOAD_CANCEL_SNAP_DELAY_TIME = 100;

  // 形成堆叠前，通过落位元素key拷贝pixmap用于动效衔接
  public static readonly FORM_STACK_COPY_DRAG_ITEM_SNAP_MSG = 'formStackDragItemKey';

  // 堆叠蒙层宽度补齐，子卡数量边界
  public static readonly FORM_STACK_MASK_EXTRA_WIDTH_LEVEL_NUM = 5;

  // 堆叠5张以内蒙层补齐宽度：vp
  public static readonly FORM_STACK_LESS_MASK_EXTRA_WIDTH = 2;

  // phone设备-堆叠5张以上蒙层补齐宽度：vp
  public static readonly FORM_STACK_MORE_MASK_EXTRA_WIDTH = 4;

  // pad设备-堆叠5张以上蒙层补齐宽度：vp
  public static readonly FORM_STACK_PAD_MORE_MASK_EXTRA_WIDTH = 5;

  // 堆叠遮罩截图自销毁延时时长：ms
  public static readonly FORM_STACK_SNAP_VIEW_DISAPPEAR_DELAY = 800;
}

/**
 * 展开卡片的显示状态
 */
export enum EditCardCollapseType {
  NONE = 0, // 所有卡片可见
  TOP_COLLAPSE = 1, // 顶部折叠
  BOTTOM_COLLAPSE = 2, // 底部折叠
}

/**
 * 展开卡片侧滑离手结果
 */
export enum EditLateralEndResult {
  RESTORE = 0, // 还原
  STAND_BY = 1, // 待删除
  DELETE = 2, // 删除
}