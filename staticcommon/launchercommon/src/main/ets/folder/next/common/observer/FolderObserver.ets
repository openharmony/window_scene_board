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

import { NumberConstants } from '@ohos/commonconstants';
import { BaseObserver } from './BaseObserver';
import { FolderCommonUtil } from '../FolderCommonUtil';

/**
 * 文件夹图标的observer
 */
@ObservedV2
export class FolderObserver extends BaseObserver {
  public opacity: number = NumberConstants.CONSTANT_NUMBER_ONE;
  public scaleX: number = NumberConstants.CONSTANT_NUMBER_ONE;
  public scaleY: number = NumberConstants.CONSTANT_NUMBER_ONE;
  public transX: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  public transY: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  public folderWidth: number = 0;
  public folderHeight: number = 0;
  public folderRadius: number = 0;
  public rowTemplate: string = '1fr 1fr 1fr';
  public columnTemplate: string = '1fr 1fr 1fr';
  public rowSize: number = 2;
  public columnSize: number = 2;

  public initTemplate(countInColumn: number, countInRow: number): void {
    this.rowTemplate = FolderCommonUtil.getTemplate(countInColumn);
    this.columnTemplate = FolderCommonUtil.getTemplate(countInRow);
  }
}