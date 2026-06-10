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

export interface SafeAreaInsetsInterface {
  top?: number;
  leading?: number;
  bottom?: number;
  trailing?: number;
}

@Observed
export class SafeAreaInsets {
  @Track public top: number;
  @Track public leading: number;
  @Track public bottom: number;
  @Track public trailing: number;

  constructor(args?: SafeAreaInsetsInterface) {
    this.top = args?.top ?? 0;
    this.leading = args?.leading ?? 0;
    this.bottom = args?.bottom ?? 0;
    this.trailing = args?.trailing ?? 0;
  }
}
