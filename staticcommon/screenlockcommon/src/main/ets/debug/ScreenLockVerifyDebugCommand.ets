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
import { DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ScreenLockVerifyService } from '../services/ScreenLockVerifyService';
import { VerifyDataManager } from '../manager/VerifyDataManager';
import { AuthType } from '../utils/AccountHelper';
import { ScreenLockDebugCommand } from './ScreenLockDebugCommand';
import { OnAcquireInfo } from '../services/ScreenLockVerifyService';
import { SLAutoTestService } from '../services/autoTest/SLAutoTestService';
import { osAccount } from '@kit.BasicServicesKit';

const TAG: string = 'ScreenLockVerifyDebugCommand';

const AUTH_SWITCH_ID = 8;

export class ScreenLockVerifyDebugCommand extends ScreenLockDebugCommand {
  constructor() {
    super();
  }

  protected doInit(params?: number | object | undefined): void {
    this.register();
  }

  protected doRelease(): void {
    this.unregister();
  }

  public register(): void {
    let cmds: DebugCommand[] = [
    // 锁屏自动化测试 -> 人脸解锁
      {
        cmdName: 'faceAuth',
        callback: (args: string[]): string => {
          if (args.length === 0) {
            return 'faceAuth params Error';
          }
          // 锁屏自动化测试 -> 执行解锁onAcquire
          SLAutoTestService.getInstance()
            .sendMessage(AuthType.FACE, Number(args[0]), (result: OnAcquireInfo | Array<number>) => {
              ScreenLockVerifyService.getInstance().launchAcquire(result as OnAcquireInfo);
            });
          return 'faceAuth SUCCESS';
        }
      },
      // 锁屏自动化测试 -> 指纹解锁
      {
        cmdName: 'fpAuth',
        callback: (args: string[]): string => {
          if (args.length === 0) {
            return 'fpAuth params Error';
          }
          // 锁屏自动化测试 -> 执行解锁onAcquire
          SLAutoTestService.getInstance().sendMessage(AuthType.FINGERPRINT, Number(args[0]),
            (result: OnAcquireInfo | Array<number>) => {
              ScreenLockVerifyService.getInstance().launchAcquire(result as OnAcquireInfo);
            });
          return 'fpAuth SUCCESS';
        }
      },
      // 锁屏自动化测试 -> 解锁开关
      {
        cmdName: 'authSwitch',
        callback: (args: string[]): string => {
          if (args.length === 0) {
            return 'fpAuth params Error';
          }
          SLAutoTestService.getInstance().sendMessage(AUTH_SWITCH_ID, args[0],
            (result: OnAcquireInfo | Array<number>) => {
              let finalResult: osAccount.EnrolledCredInfo[] = [];
              for (let auth of result as Array<number>) {
                finalResult.push({
                  credentialId: new Uint8Array(),
                  authType: auth,
                  authSubType: auth,
                  templateId: new Uint8Array()
                });
              }
              // 锁屏自动化测试 -> 测试注入生物认证开关信息
              VerifyDataManager.getInstance().updateVerifyData(finalResult);
            });
          return 'authSwitch SUCCESS';
        }
      },
    ];
    DebugCommandManager.getInstance().register(TAG, cmds);
  }

  public unregister(): void {
    DebugCommandManager.getInstance().unregister(TAG);
  }
}