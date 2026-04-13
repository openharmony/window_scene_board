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

export class BindSheetStateData {
  @Track public isShow: boolean = false;
  @Track public height: number = 0;
  @Track public isSupportSplit: boolean = false;
  @Track public changeDetents: boolean = false;
  @Track public setHeight?: number = 0;
  @Track public maxHeight?: number = 0;
  @Track public sheetOffset?: Position = undefined;

  public resetData(): void {
    this.isShow = false;
    this.height = 0;
    this.isSupportSplit = false;
    this.changeDetents = false;
    this.setHeight = 0;
    this.maxHeight = 0;
    this.sheetOffset = undefined;
  }
}