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
 * 拖拽热区位置
 */
export enum ZoomPosition {
  LEFT = 1,
  TOP = 1 << 1,
  RIGHT = 1 << 2,
  BOTTOM = 1 << 3,
  LEFT_TOP = LEFT | TOP,
  RIGHT_TOP = RIGHT | TOP,
  RIGHT_BOTTOM = RIGHT | BOTTOM,
  LEFT_BOTTOM = LEFT | BOTTOM,
  NONE = 0
}

/**
 * 拖拽热区数据
 */
export interface ZoomHotArea {
  offsetX: string;
  offsetY: string;
  width: string | number;
  height: string | number;
  position: ZoomPosition;
}

/**
 * 拖拽放缩类型
 */
export enum ZoomType {
  ZOOM_IN,
  ZOOM_OUT
}

/**
 * 拖拽放缩后的区域大小和偏移量
 */
export interface AreaOffset {
  rowOffset: number;
  columnOffset: number;
  area: number[];
  cardDimension: number;
}

/**
 * 卡片拖拽放缩后的目标区域
 */
export interface FormZoomTargetArea {
  canZoom: boolean;
  row: number;
  column: number;
  area: number[];
  alignContent: Alignment;
  cardDimension: number;
}

/**
 * 卡片拖拽放缩的结果
 */
export interface CheckZoomResult {
  zoomType: ZoomType;
  targetAreaList: FormZoomTargetArea[];
}

/**
 * 卡片拖拽放缩的偏移量
 */
export interface ZoomOffset {
  offsetX: number;
  offsetY: number;
}

/**
 * 卡片拖拽放缩事件类型
 */
export enum FormZoomDragEvtType {
  DRAG_START,
  DRAG_MOVE,
  DRAG_END
}

/**
 * 卡片拖拽放缩事件参数
 */
export interface FormZoomDragEvtParams {
  type: FormZoomDragEvtType;
  offsetX: number;
  offsetY: number;
}

export enum Directions {
  LEFT,
  RIGHT,
  TOP,
  BOTTOM
}