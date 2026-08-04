/**
 * Copyright (c) 2021-2023 Huawei Device Co., Ltd.
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

export const folderLayoutInfo: FolderLayoutInfo = {
  bigFolderLayoutTable: {
    id: 0,
    layout: '3X3',
    name: '3X3',
    row: 3,
    column: 3,
    area: [2, 2],
    checked: false
  },
  folderOpenLayoutTable:
  {
    id: 1,
    layout: '4X3',
    name: '4X3',
    row: 4,
    column: 3,
    checked: false
  },
  folderAddAppLayoutTable:
  {
    id: 2,
    layout: '6X4',
    name: '6X4',
    row: 6,
    column: 4,
    checked: false
  },
  smallFolderLayoutTable: {
    id: 3,
    layout: '3X3',
    name: '3X3',
    row: 3,
    column: 3,
    area: [1, 1],
    checked: false
  },
  folderOpenLayoutInfoInPadOrExpand: {
    id: 4,
    layout: '4X4',
    name: '4X4',
    row: 4,
    column: 4,
    checked: false
  },
  folderAddLayoutInPadOrExpand:
  {
    id: 5,
    layout: '6X5',
    name: '6X5',
    row: 6,
    column: 5,
    checked: false
  },
};

export class FolderLayoutStruct {
  public id: number = 0;
  public layout: string = '';
  public name: string = '';
  public row: number = 0;
  public column: number = 0;
  public area?: number[];
  public checked: boolean = false;
}

export interface FolderLayoutInfo {
  bigFolderLayoutTable: FolderLayoutStruct;
  folderOpenLayoutTable: FolderLayoutStruct;
  folderAddAppLayoutTable: FolderLayoutStruct;
  smallFolderLayoutTable: FolderLayoutStruct;
  folderOpenLayoutInfoInPadOrExpand?: FolderLayoutStruct;
  // 平板或折叠屏展开态下，文件夹添加dialog的布局
  folderAddLayoutInPadOrExpand?: FolderLayoutStruct;
}
