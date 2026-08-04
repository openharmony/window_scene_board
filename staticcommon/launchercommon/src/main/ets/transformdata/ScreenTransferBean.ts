/**
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import type { BaseTransferBean } from './BaseTransferBean';

export default class ScreenTransferBean {
  public page: number = 0;
  public occupied: boolean[][] = [];
  public usedCellCnt: number = 0;
  public iconUsedCellCnt: number = 0;
  public folderUsedCellCnt: number = 0;
  public abilityFormUsedCellCnt: number = 0;
  public children: BaseTransferBean[] = [];
  public moveToNextPage: BaseTransferBean[] = [];
}