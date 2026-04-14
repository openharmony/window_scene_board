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

import { FolderType } from '../../../common/FolderCommonConstant';
import { FolderAppItemInfo } from '../../../../../TsIndex';

@ObservedV2
export class ContractedFolderImageObserver {
  @Trace public convertFolderId: string = '';
  @Trace public animateTranslateX: number = 0;
  @Trace public animateTranslateY: number = 0;
  @Trace public bigFolderTransX: number = 0;
  @Trace public bigFolderTransY: number = 0;
  @Trace public smallFolderTransX: number = 0;
  @Trace public smallFolderTransY: number = 0;
  @Trace public isShowBigFolderBg: boolean = false;
  @Trace public bigFolderType: number = FolderType.AREA_2X2_1X1;
  @Trace public mBigHideAppList: FolderAppItemInfo[] = [];
  @Trace public mBigShowAppList: FolderAppItemInfo[] = [];
  @Trace public mColTemplate: string = '1fr 1fr 1fr';
  @Trace public mRowTemplate: string = '1fr 1fr 1fr';
  @Trace public mSmallShowAppList: FolderAppItemInfo[] = [];
  @Trace public mSmallHideAppList: FolderAppItemInfo[] = [];
  @Trace public mAnimaSequenceArray: boolean[] = new Array(8).fill(false);
  @Trace public page: number = 0;
  @Trace public isConvertSmall: boolean = false;
  @Trace public convertBigArea: number[] = [1, 1];
  public convertAnimateFunc?: () => void;
  public isanimateReady: boolean = false;
  public isFolderChange: boolean = false;
}