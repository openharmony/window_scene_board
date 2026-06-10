/**
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved. 2024-2025. All rights reserved.
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

export class GridLayoutConfig {
  public id: number = 0;
  public layout: string = '';
  public name: string = '';
  public value: number = 0;
  public row: number = 0;
  public column: number = 0;
  public checked: boolean = false;
}

const GRID_LAYOUT_TABLE_4X4: GridLayoutConfig = {
  id: 0,
  layout: '4X4',
  name: '4X4',
  value: 1,
  row: 4,
  column: 4,
  checked: false
};

const GRID_LAYOUT_TABLE_5X4: GridLayoutConfig = {
  id: 1,
  layout: '5X4',
  name: '5X4',
  value: 0,
  row: 5,
  column: 4,
  checked: false
};

const GRID_LAYOUT_TABLE_6X4: GridLayoutConfig = {
  id: 2,
  layout: '6X4',
  name: '6X4',
  value: 2,
  row: 6,
  column: 4,
  checked: false
};

const GRID_LAYOUT_TABLE_HORIZONTAL_2X6: GridLayoutConfig = {
  id: 0,
  layout: '2X6',
  name: '2X6',
  value: 0,
  row: 2,
  column: 6,
  checked: false
};

const PAD_GRID_LAYOUT_TABLE_HORIZONTAL_5X11: GridLayoutConfig = {
  id: 0,
  layout: '5X11',
  name: '5X11',
  value: 0,
  row: 5,
  column: 11,
  checked: false
};

const PAD_GRID_LAYOUT_TABLE_HORIZONTAL_4X10: GridLayoutConfig = {
  id: 1,
  layout: '4X10',
  name: '4X10',
  value: 1,
  row: 4,
  column: 10,
  checked: false
};

const PAD_GRID_LAYOUT_TABLE_HORIZONTAL_4X9: GridLayoutConfig = {
  id: 2,
  layout: '4X9',
  name: '4X9',
  value: 2,
  row: 4,
  column: 9,
  checked: false
};

const GridLayoutConfigs: ILayoutConfigs = {
  GridLayoutTable: [
    GRID_LAYOUT_TABLE_4X4,
    GRID_LAYOUT_TABLE_5X4,
    GRID_LAYOUT_TABLE_6X4
  ],
  GridLayoutTableHorizontal: [
    GRID_LAYOUT_TABLE_HORIZONTAL_2X6
  ],
  PadGridLayoutTableHorizontal: [
    PAD_GRID_LAYOUT_TABLE_HORIZONTAL_5X11,
    PAD_GRID_LAYOUT_TABLE_HORIZONTAL_4X10,
    PAD_GRID_LAYOUT_TABLE_HORIZONTAL_4X9
  ],
};

export interface ILayoutConfigs {
  GridLayoutTable: GridLayoutConfig[];
  GridLayoutTableHorizontal: GridLayoutConfig[];
  PadGridLayoutTableHorizontal: GridLayoutConfig[]
}

export default GridLayoutConfigs;