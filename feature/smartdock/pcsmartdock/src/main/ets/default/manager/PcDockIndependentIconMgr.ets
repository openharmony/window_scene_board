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
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import bundleManager from '@ohos.bundle.bundleManager';
import { AppItemInfo } from '@ohos/launchercommon';
import { HashMap } from '@kit.ArkTS';
import { SCBSceneSession } from '@ohos/windowscene';

const TAG = 'PcDockIndepentIconMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

export class PcDockIndepentIconMgr {
  private static instance: PcDockIndepentIconMgr;
  private independentIconAbilitys: HashMap<string, string[]> = new HashMap();

  public static getInstance(): PcDockIndepentIconMgr {
    if (!PcDockIndepentIconMgr.instance) {
      PcDockIndepentIconMgr.instance = new PcDockIndepentIconMgr();
    }
    return PcDockIndepentIconMgr.instance;
  }

  public addIndependentIconAbility(bundleName: string, persistentId: string): void {
    if (CheckEmptyUtils.isEmpty(bundleName) || CheckEmptyUtils.isEmpty(persistentId)) {
      return;
    }
    if (!this.independentIconAbilitys.hasKey(bundleName)) {
      let persistentIdArry: string[] = [];
      persistentIdArry.push(persistentId);
      this.independentIconAbilitys.set(bundleName, persistentIdArry);
    } else {
      let persistentIdArry: string[] = this.independentIconAbilitys.get(bundleName);
      if (!persistentIdArry.includes(persistentId)) {
        persistentIdArry.push(persistentId);
        this.independentIconAbilitys.set(bundleName, persistentIdArry);
      }
    }
  }

  public removeIndependentIconAbility(bundleName: string, persistentId: string): void {
    if (CheckEmptyUtils.isEmpty(bundleName) || CheckEmptyUtils.isEmpty(persistentId)) {
      return;
    }
    if (!this.independentIconAbilitys.hasKey(bundleName)) {
      return;
    }
    let persistentIdArry: string[] = this.independentIconAbilitys.get(bundleName);
    persistentIdArry = persistentIdArry.filter(id => id !== persistentId);
    if (persistentIdArry.length > 0) {
      this.independentIconAbilitys.set(bundleName, persistentIdArry);
    } else {
      this.independentIconAbilitys.remove(bundleName);
    }
  }

  public isIndependentIconAbility(bundleName: string, persistentId: string): boolean {
    if (CheckEmptyUtils.isEmpty(bundleName) || CheckEmptyUtils.isEmpty(persistentId)) {
      return false;
    }
    if (!this.independentIconAbilitys.hasKey(bundleName)) {
      return false;
    }
    let persistentIdArry: string[] = this.independentIconAbilitys.get(bundleName);
    return persistentIdArry.includes(persistentId);
  }

  public checkIsIndependentIconSession(scbSceneSession: SCBSceneSession | null): boolean {
    if (CheckEmptyUtils.isEmpty(scbSceneSession) || CheckEmptyUtils.isEmpty(scbSceneSession?.sceneInfo)) {
      return false;
    }

    let bundleName: string = scbSceneSession?.sceneInfo?.bundleName ?? '';
    return this.isIndependentIconAbility(bundleName, String(scbSceneSession?.sceneInfo?.persistentId));
  }

  public getIndependentIconAbilities(bundleName: string,): string[] {
    let empty: string[] = [];
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      return empty;
    }
    if (this.independentIconAbilitys.hasKey(bundleName)) {
      return this.independentIconAbilitys.get(bundleName);
    }
    return empty;
  }

}