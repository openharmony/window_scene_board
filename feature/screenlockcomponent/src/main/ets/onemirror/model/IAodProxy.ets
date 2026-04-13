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

import { AodElemPosition } from '@ohos/themeservice';

export default interface IAodProxy {
  checkAod: () => void;
  isFingerprintEnable: () => boolean;
  isFullScreenAOD: () => boolean;
  isPartScreenAOD: () => boolean;
  isPartEmoji: () => boolean;
  isAODEnable: () => boolean;
  start: (isSupportScreenToEnd: boolean) => Promise<void>;
  stop: (screenStatus: number) => Promise<void>;
  isAodDataInValid: () => boolean;
  updateTPState: (isOpen: boolean) => void;
  isAodShow?: () => boolean;
  isFingerprintShow?: () => boolean;
  isPartAodPlayMirror: () => boolean;
  isFullAodPlayMirror: () => boolean;
  isOnlineMixAod: () => boolean;
  getAodLayerInfo: (isRealtime: boolean) => Promise<AodElemPosition>;
  isPartMirrorAod: () => boolean;
}