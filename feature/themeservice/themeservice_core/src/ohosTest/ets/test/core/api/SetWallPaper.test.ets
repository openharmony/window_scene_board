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
import { describe, expect, it, Level, TestType } from '@ohos/hypium';
import { TSOhosTestManger } from '../../../core/TSOhosTestManger';
import { WallPaper } from '@ohos/themeservice_inner_api/Index';
import { ThemePresetDataGetter } from '../../../core/util/ThemePresetDataGetter';
import { WallPaperInfo } from '@ohos/themeservice_inner_api/Index';
import { AssertUtils } from '../../../core/util/AssertUtils';

export default function SetWallPaperTest() {
  describe('SetWallPaperTest', () => {
    it('test001_setDefaultWallPaper', 0, async () => {
      let lockWallPaper: WallPaper = new WallPaper();
      lockWallPaper.src = await ThemePresetDataGetter.getDefaultLockWallPaper();
      let defaultLockWallPaper: WallPaperInfo = new WallPaperInfo([lockWallPaper], 'lock');
      let homeWallPaper: WallPaper = new WallPaper();
      homeWallPaper.src = await ThemePresetDataGetter.getDefaultHomeWallPaper();
      let defaultHomeWallPaper: WallPaperInfo = new WallPaperInfo([homeWallPaper], 'home');
      let success: boolean = await TSOhosTestManger.getTsCoreRemoteApi()
        .setWallPaper([defaultLockWallPaper, defaultHomeWallPaper]);
      expect(success).assertTrue();
    })

    it('test002_setInvalidWallPaper', 0, async () => {
      let lockWallPaper: WallPaper = new WallPaper();
      lockWallPaper.src = 'data/invalid/wallpaper';
      let defaultLockWallPaper: WallPaperInfo = new WallPaperInfo([lockWallPaper], 'lock');
      let success: boolean = await TSOhosTestManger.getTsCoreRemoteApi()
        .setWallPaper([defaultLockWallPaper]);
      expect(success).assertFalse();
    })

    it('test003_setInvalidWallPaper', 0, async () => {
      let success: boolean = await TSOhosTestManger.getTsCoreRemoteApi().setWallPaper([]);
      expect(success).assertFalse();
    })

    it('test004_setInvalidWallPaper', 0, async () => {
      let defaultLockWallPaper: WallPaperInfo = new WallPaperInfo([], 'lock');
      let success: boolean = await TSOhosTestManger.getTsCoreRemoteApi().setWallPaper([defaultLockWallPaper]);
      expect(success).assertFalse();
    })

    it('test005_setInvalidWallPaper', 0, async () => {
      let lockWallPaper: WallPaper = new WallPaper();
      let defaultLockWallPaper: WallPaperInfo = new WallPaperInfo([lockWallPaper], 'lock');
      let success: boolean = await TSOhosTestManger.getTsCoreRemoteApi().setWallPaper([defaultLockWallPaper]);
      expect(success).assertFalse();
    })

    it('test006_setDefaultWallPaper', 0, async () => {
      let wallPapers: WallPaperInfo[] = await createWallPaper('unfolded');
      let success: boolean = await TSOhosTestManger.getTsCoreRemoteApi().setWallPaper(wallPapers);
      expect(success).assertTrue();
    })

    it('test007_setDefaultWallPaper', 0, async () => {
      let wallPapers: WallPaperInfo[] = await createWallPaper();
      let success: boolean = await TSOhosTestManger.getTsCoreRemoteApi().setWallPaper(wallPapers);
      expect(success).assertTrue();
    })

    it('test008_setInvalidWallPaper', 0, async () => {
      let lockWallPaper: WallPaper = new WallPaper();
      lockWallPaper.src = await ThemePresetDataGetter.getDefaultLockWallPaper();
      let defaultLockWallPaper: WallPaperInfo = new WallPaperInfo([], 'home');
      let homeWallPaper: WallPaper = new WallPaper();
      homeWallPaper.src = await ThemePresetDataGetter.getDefaultHomeWallPaper();
      let defaultHomeWallPaper: WallPaperInfo = new WallPaperInfo([homeWallPaper], 'lock');
      let success: boolean = await TSOhosTestManger.getTsCoreRemoteApi()
        .setWallPaper([defaultLockWallPaper, defaultHomeWallPaper]);
      expect(success).assertFalse();
    })

    it('test009_setWallPaper_parallel', TestType.SECURITY | Level.LEVEL1, async () => {
      let homeWallPaper: WallPaper = new WallPaper();
      let defaultHomeWallPaper: WallPaperInfo = new WallPaperInfo([homeWallPaper], 'home');
      await AssertUtils.expectParallelInvoke(() => TSOhosTestManger.getTsCoreRemoteApi()
        .setWallPaper([defaultHomeWallPaper]))
    })
  })
}

async function createWallPaper(category: string = 'base'): Promise<WallPaperInfo[]> {
  let lockWallPaper: WallPaper = new WallPaper();
  lockWallPaper.src = await ThemePresetDataGetter.getDefaultLockWallPaper();
  lockWallPaper.category = category;
  lockWallPaper.contentType = 'video';
  let defaultLockWallPaper: WallPaperInfo = new WallPaperInfo([lockWallPaper], 'lock');
  defaultLockWallPaper.type = 'movingPhoto';
  let homeWallPaper: WallPaper = new WallPaper();
  homeWallPaper.src = await ThemePresetDataGetter.getDefaultHomeWallPaper();
  homeWallPaper.category = category;
  let defaultHomeWallPaper: WallPaperInfo = new WallPaperInfo([homeWallPaper], 'home');
  defaultHomeWallPaper.type = 'movingPhoto';
  return [defaultLockWallPaper, defaultHomeWallPaper]
}
