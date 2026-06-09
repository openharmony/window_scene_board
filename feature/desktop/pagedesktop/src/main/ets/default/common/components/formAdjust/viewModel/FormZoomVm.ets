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

@Observed
export class FormZoomVm {
  public width: number = 0;
  public height: number = 0;
  public alignContent: Alignment = 0;
}

/**
 * 拖拽热区点的显示状态
 */
@Observed
export class ZoomBarVisible {
  public left: boolean;
  public top: boolean;
  public right: boolean;
  public bottom: boolean;

  constructor(left: boolean, top: boolean, right: boolean, bottom: boolean) {
    this.left = left;
    this.top = top;
    this.right = right;
    this.bottom = bottom;
  }
}