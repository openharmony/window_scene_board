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
 */
export interface DragEventParams {
  /**
   * ArkUI拖拽事件event参数
   */
  event: DragEvent;

  /**
   * ArkUI拖拽事件extraParams参数
   */
  extraParams?: string;
}

/**
 * 被拖ITEM信息
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
 */
export interface DragGridInfo {
  /**
   * 被拖ITEM信息
   */
  dragItem: DragGridItem[];

  /**
   * 拖拽开始场景
   */
  from: DragScene;

  /**
   * 拖拽结束场景
   */
  to?: DragScene;
}

/**
 * 拖拽所处范围的宫格尺寸参数
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
}

/**
 * 拖拽所处范围的布局信息
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
 * 拖拽场景
 */
export enum DragScene {
  /* 未知 */
  UNKNOWN = 0,

  /* dock栏 */
  DOCK = 1,

  /* 桌面 */
  DESKTOP = 2,

  /* 文件夹展开态 */
  FOLDER = 3,

  /* 卡片管理 */
  MANAGE = 4,

  /* 上滑卡片 */
  SWIPE_UP = 5,

  /* 卡片服务 */
  FORM_SERVICE = 6,

  /* 负一屏 */
  FORM_INTELLIGENT = 7,

  /* dock栏文件夹展开态 */
  FOLDER_IN_DOCK = 8,

  /* 卡片堆叠 */
  FORM_STACK = 9,

  /* 快捷菜单 */
  SHORTCUT = 10,
}