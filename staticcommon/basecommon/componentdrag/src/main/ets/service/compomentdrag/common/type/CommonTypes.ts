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
import { DragEvent } from 'DragControllerParam';

/**
 * 拖拽、挤位通用参数
 *
 * @since 2024/03/14
 */
export interface DragEventParams {
  /**
   * ARKUI拖拽事件event参数
   */
  event: DragEvent;

  /**
   * ARKUI拖拽事件extraParams参数
   */
  extraParams?: string;
}

/**
 * 被拖ITEM信息
 *
 * @since 2024/03/15
 */
export interface DragGridItem {
  /**
   * 被拖ITEM所在的行索引(从0开始计数)
   */
  row?: number;

  /**
   * 被拖ITEM所在的列索引(从0开始计数)
   */
  column?: number;

  /**
   * 被拖ITEM的面积
   */
  area?: number[];
}

/**
 * 拖拽行为信息，支持拓展
 *
 * @since 2024/03/20
 */
export interface DragGridInfo {
  /**
   * 被拖ITEM信息
   */
  dragItem: DragGridItem;

  /**
   * 拖拽类型
   */
  dragType?: DragType;
}

/**
 * 拖拽所处范围的宫格尺寸参数
 *
 * @since 2024/03/20
 */
export interface DragGridParam {
  /**
   * 宫格左内边距
   */
  paddingLeft: number;

  /**
   * 宫格上内边距
   */
  paddingTop: number;

  /**
   * 宫格总行数
   */
  row: number;

  /**
   * 宫格总列数
   */
  column: number;

  /**
   * 宫格行间距
   */
  rowGap: number;

  /**
   * 宫格列间距
   */
  columnGap: number;

  /**
   * 宫格总宽度
   */
  gridWidth: number;

  /**
   * 宫格总高度
   */
  gridHeight: number;

  /**
   * 宫格元素宽度
   */
  itemWidth?: number;

  /**
   * 宫格元素高度
   */
  itemHeight?: number;
}

/**
 * 实际各方向内边距尺寸参数
 */
export interface RealPaddingParam {
  paddingTop: number;
  paddingBottom: number;
  paddingLeft: number;
  paddingRight: number;
}

/**
 * 拖拽所处范围的布局信息
 *
 * @since 2024/03/20
 */
export interface DragGridLayout {
  /**
   * 宫格尺寸参数
   */
  gridParam: DragGridParam;

  /**
   * 宫格布局数组
   */
  layout: DragGridItem[];

  /**
   * 判断布局内元素是否相同
   */
  equal: (origin: DragGridItem, target: DragGridItem) => boolean;
}

/**
 * 屏幕位置坐标
 *
 * @since 2024/04/20
 */
export interface DragPosition {
  /**
   * 相对屏幕左上角的x轴坐标
   */
  x: number;

  /**
   * 相对屏幕左上角的y轴坐标
   */
  y: number;
}

/**
 * 宫格位置坐标
 *
 * @since 2024/04/20
 */
export interface DragGridPosition {
  /**
   * 宫格行索引(从0开始计数)
   */
  row: number;

  /**
   * 宫格列索引(从0开始计数)
   */
  column: number;

  /**
   * 宫格页面
   */
  page?: number;
}

/**
 * 拖拽相关回调参数
 */
export interface DragCallbackParams {
  /**
   * 拖拽、挤位通用参数
   */
  eventParams: DragEventParams;

  /**
   * 拖拽行为相关信息
   */
  dragInfo: DragGridInfo;

  /**
   * 拖拽元素中心点相对屏幕位置坐标
   */
  position: DragPosition;

  /**
   * 拖拽元素目标宫格位置坐标
   */
  gridPosition?: DragGridPosition;
}

/**
 * 拖拽行为类型
 *
 * @since 2024/04/20
 */
export enum DragType {
  /**
   * 未发生拖拽
   */
  NOT_IN_DRAG = -1,

  /**
   * dock栏起拖
   */
  DRAG_FROM_DOCK = 1,

  /**
   * 桌面起拖
   */
  DRAG_FROM_DESKTOP = 2,

  /**
   * 文件夹内起拖
   */
  DRAG_FROM_FOLDER = 3,

  /**
   * 卡片管理起拖
   */
  DRAG_FROM_MANAGE = 4,

  /**
   * 上滑卡片起拖
   */
  DRAG_FROM_SWIPE_UP = 5,

  /**
   * 卡片服务起拖
   */
  DRAG_FROM_FORM_SERVICE = 6,

  /**
   * 负一屏起拖
   */
  DRAG_FROM_FORM_INTELLIGENT = 7,

  /**
   * dock栏内文件夹起拖
   */
  DRAG_FROM_FOLDER_IN_DOCK = 8,

  /**
   * 卡片堆叠起拖
   */
  DRAG_FROM_FORM_STACK = 9,

  /**
   * 快捷菜单页起拖
   */
  DRAG_FROM_SHORTCUT = 10,
}