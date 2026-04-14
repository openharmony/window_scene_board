/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

export { AdaptCutMargin, ScreenLockCutOutUtil } from '@ohos/screenlockwidget/src/main/ets/common/utils/ScreenLockCutOutUtil';
export { default as FreezingTipUtil } from './src/main/ets/common/FreezingTipUtil';
export { ScbServiceRemoteObject } from './src/main/ets/common/SCBServiceRemoteObject';
export { VerifyTipsUtils } from './src/main/ets/tips/utils/VerifyTipsUtils';
export { clockLayoutHelper } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutHelper';

export { SpecialModeManager,
  SpecialModeViewData,
  SpecialModeChangeListener } from './src/main/ets/common/SpecialModeManager';
export {
  OneMirrorAnimationPara,
  OneMirrorLayoutPara,
  OneMirrorLayoutType,
  OneMirrorSceneParaData,
  OneMirrorAnimateCallback,
  ImmersiveOneMirror
} from './src/main/ets/onemirror/utils/OneMirrorParaUtil';
export { ScreenLockVc } from './src/main/ets/common/ScreenLockVc';

export { IOneMirrorStrategy } from './src/main/ets/onemirror/model/IOneMirrorStrategy';
export { OneMirrorStrategyContext } from './src/main/ets/onemirror/strategy/OneMirrorStrategyContext';

export { EventAdapterManager } from './src/main/ets/adapter/EventAdapterManapger';

export { default as ScreenLockAVPlayerManager } from './src/main/ets/tone/ScreenLockAVPlayerManager';

export { GestureNaviUtil } from './src/main/ets/utils/GestureNaviUtil';

export { MirrorScene, MirrorSceneUtils, OneMirrorService } from './src/main/ets/onemirror/service/OneMirrorService';
export type { FinishCallback, OneMirrorListener } from './src/main/ets/onemirror/service/OneMirrorService';

export { VerifyResultInfo, VerifyTipsService } from './src/main/ets/tips/service/VerifyTipsService';
export type { VerifyTipsListener } from './src/main/ets/tips/service/VerifyTipsService';

export { SlObserverProxy } from './src/main/ets/observer/SlObserverProxy';

export { AodSlideAdapter } from './src/main/ets/adapter/AodSlideAdapter';

