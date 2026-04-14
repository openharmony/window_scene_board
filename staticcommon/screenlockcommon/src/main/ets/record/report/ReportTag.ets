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
export const PNAMEID: string = 'com.ohos.sceneboard';
export const PVERSIONID: string = 'sceneBoard';


/*
 * 锁屏UE点位
 */
export class SLUETag {
  // 进入锁屏（锁屏上树）
  public static readonly INTOKEYGUARD = 'INTOKEYGUARD';

  // 退出锁屏（锁屏下树）
  public static readonly EXITKEYGUARD = 'EXITKEYGUARD';

  // 隐藏锁屏（设置透明，不下树）
  public static readonly HIDESCREENLOCK = 'HIDESCREENLOCK'
}

/*
 * 锁屏故障点位
 */
export class SLFaultTag {
  // onAcquire和onResult结果不一致
  public static readonly ACQUIRE_RESULT_DIFF = 'ACQUIRE_RESULT_DIFF'
}