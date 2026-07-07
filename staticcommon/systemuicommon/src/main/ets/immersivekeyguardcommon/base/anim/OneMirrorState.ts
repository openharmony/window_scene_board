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
import { ImmersiveAodStyle } from '../interface/ImmersiveAodStyle';

/**
 * 锁屏AOD一镜到底动效状态管理
 */
@Observed
export class OneMirrorState {
  /**
   * AOD显示样式
   */
  @Track private aodStyle: ImmersiveAodStyle = new ImmersiveAodStyle();

  /**
   * 获取Aod样式
   *
   * @returns Aod样式
   */
  getAodStyle(isKeyguard?: boolean): ImmersiveAodStyle | undefined {
    if (isKeyguard === undefined || !isKeyguard) {
      return undefined;
    }
    return this.aodStyle;
  }
}