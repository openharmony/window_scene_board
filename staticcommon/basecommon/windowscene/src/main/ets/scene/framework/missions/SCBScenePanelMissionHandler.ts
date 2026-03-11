/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneSession,
  SCBScreenProperty
} from '../../../TsIndex';
import { SCBSceneInfo } from '../../session/SCBSceneInfo';
import { MissionTemplateProcessor } from '../missiontemplate/BasicSceneMissionTemplate';
import { PANEL_ID_CONCAT_CONSTANT } from './SCBBaseScenePanelViewModel';
import {
  SCBMainSessionTuple,
  SCBMinimizeSceneOpts,
  SCBSceneMissionType,
  SCBTerminateSceneOpts,
  SCBTransferSceneOpts,
  SCBTransitionSceneOpts,
  SCBStartSceneOpts
} from './SCBSceneMissionTypes';
import {
  SCBSceneMissionManager
} from '../../SceneModuleIndex';
import { INVALID_PERSISTENT_ID } from '../../session/SCBSceneSession';
import { CommonResult } from '../../../scene/utils/SCBSceneUtils';

const TAG: string = '[SCBMission]SCBScenePanelMissionHandler';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export const DEFAULT_TOTAL_LIST_TAG = 'total';

/**
 * SceneMission handler, will responses to start/terminate scenes.
 */
export class SCBScenePanelMissionHandler {
  public screenId: number;
  public panelId: number; // auto defined by fwk.
  public screenProperty: SCBScreenProperty;
  // default set a total list for this panel.
  public totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
  // SCBSceneContainerSessionArray grouped by usage, like default(total)/fullScene/floatingScene/dockerScene and more.
  private containerSessionMap: Map<string, SCBSceneContainerSessionArray> = new Map();
  private missionTemplates: Map<SCBSceneMissionType, MissionTemplateProcessor> = new Map();

  /**
   * constructor
   * @param screenProperty must set the property of current screen.
   */
  constructor(screenProperty: SCBScreenProperty = new SCBScreenProperty()) {
    this.screenId = screenProperty.screenId;
    this.panelId = SCBSceneMissionManager.getInstance().preAssignPanelId(screenProperty.screenId);
    this.screenProperty = screenProperty;

    this.preSetSessionLists();
    this.preSetMissionTemplates();
    log.showInfo(`${this.logTag} load count containerSessionList:${this.containerSessionMap.size}, ` +
      `missionTemplates:${this.missionTemplates.size}`);
  }

  /**
   * get id of handler
   * @returns id
   */
  public get id(): number {
    return this.panelId + (this.screenId * PANEL_ID_CONCAT_CONSTANT);
  }

  /**
   * log tag
   * @returns log tag
   */
  public get logTag(): string {
    return `[Screen:${this.screenId}][Panel:${this.panelId}]`;
  }

  /**
   * reset screen property
   * @param newProperty new SCBScreenProperty
   */
  public resetScreenProperty(newProperty: SCBScreenProperty, reason: string): void {
    if (newProperty == null) {
      return;
    }
    log.showInfo(`reset screen property: ${reason}`);
    this.screenProperty = newProperty;
    this.screenId = newProperty.screenId;
    this.panelId = SCBSceneMissionManager.getInstance().preAssignPanelId(this.screenId);
  }

  /**
   * must re-write when panel needs to allocate SCBContainerSessionArray.
   * @description default allocate a 'total' list.
   */
  protected preSetSessionLists(): void {
    this.registerContainerSessionList(DEFAULT_TOTAL_LIST_TAG, this.totalContainerSessionList);
  }

  /**
   * must re-write when panel needs to response mission management.
   */
  protected preSetMissionTemplates(): void {
  }

  protected addMissionTemplate(missionType: SCBSceneMissionType, processor: MissionTemplateProcessor): void {
    if (this.missionTemplates.has(missionType)) {
      log.showInfo(`missiontemplate of ${missionType} duplicated`);
    }
    this.missionTemplates.set(missionType, processor);
  }

  // ----------------------------------------------------------------------------------------------------
  // Scene Mission Management
  // ----------------------------------------------------------------------------------------------------
  /**
   * get inner processor for callbacks.
   * @description Warning! check return value when use.
   * @param missionType
   * @returns
   */
  private getMissionProcessor(missionType: SCBSceneMissionType): Function {
    const processor = this.missionTemplates.get(missionType)?.getProcessor();
    if (processor == null) {
      log.showWarn(`${this.logTag}getMissionProcessor null, fallback to empty default`);
      return (...args) => { return CommonResult.FAIL };
    }
    return processor;
  }

  // 归一化启动接口，例如：FromIcon, FromOther等
  onStartScene(toInfo: SCBSceneInfo, opts: SCBStartSceneOpts): void {
    this.getMissionProcessor(SCBSceneMissionType.START_SCENE)(toInfo, opts);
  }

  // 从一个应用启动另一个应用
  onStartSceneTransition(toInfo: SCBSceneInfo, fromInfo: SCBSceneInfo, opts?: SCBTransitionSceneOpts): CommonResult {
    return this.getMissionProcessor(SCBSceneMissionType.START_SCENE_TRANSITION)(toInfo, fromInfo, opts);
  }

  // 从多任务启动应用
  onStartSceneFromRecent(persistentId?: number, containerId?: number): void {
  }

  // 其他启动方式：系统服务启动例如电话
  onStartSceneFromOther(toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo): CommonResult {
    return this.getMissionProcessor(SCBSceneMissionType.START_SCENE_FROM_OTHER)(toInfo);
  }

  // 指定启动前后台模式，CallToState can be Foreground or Background
  onStartSceneByCall(toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo): void {
  }

  // 应用退后台
  onMinimizeScene(persistentId?: number, containerId?: number, opts?: SCBMinimizeSceneOpts): void {
    this.getMissionProcessor(SCBSceneMissionType.MINIMIZE_SCENE)(persistentId, containerId, opts);
  }

  // 全部应用退后台
  onMinimizeAllScene(): void {
  }

  // 应用重回前台
  onMaximizeScene(persistentId?: number, containerId?: number): void {
  }

  // 关闭窗口，归一化：closeScene, terminateScene
  onTerminateScene(persistentId?: number, containerId?: number, opts?: SCBTerminateSceneOpts): void {
    this.getMissionProcessor(SCBSceneMissionType.TERMINATE_SCENE)(persistentId, containerId, opts);
  }

  // 关闭所有窗口
  onTerminateAllScene(): void {
    for (const [usage, sessionList] of this.containerSessionMap) {
      log.showInfo(`${this.logTag} terminate all in ${usage} list, contains ${sessionList.length} sessions`);
      const containerList = Array.from(sessionList); // copy first, will read & write on one list
      for (const session of containerList) {
        this.onTerminateScene(undefined, session?.containerId, undefined);
      }
    }
  }

  /**
   * Pop scene out of panel.
   * @description only pop full-screen scene supported
   * @param persistentId persistentId of target scene to pop out.
   * * @param info info of target scene to pop out.
   * @param opts options
   * @returns SCBSceneSession or null.
   */
  onPopSceneOut(persistentId: number, sceneInfo: SCBSceneInfo, opts: SCBTransferSceneOpts): SCBSceneSession | null {
    log.showInfo(`${this.logTag}onPopSceneOut, ${opts.transferFinishedCallback ? 'with' : 'without'} animation`);
    let result = this.getMissionProcessor(SCBSceneMissionType.POP_SCENE_OUT)(persistentId, sceneInfo, opts);
    if (result && result instanceof SCBSceneSession) {
      return result;
    }
    return null;
  }

  /**
   * Push scene into panel.
   * @param session target session add
   * @param opts options
   */
  onPushSceneIn(session: SCBSceneSession, opts?: SCBTransferSceneOpts): CommonResult {
    return this.getMissionProcessor(SCBSceneMissionType.PUSH_SCENE_IN)(session, opts) ?? CommonResult.FAIL;
  }

  // 从当前容器迁移到其他容器中
  onTransferSceneOut(): SCBSceneContainerSessionArray {
    return new SCBSceneContainerSessionArray();
  }

  // 从其他容器迁移进当前容器
  onTransferSceneIn(sessionList: SCBSceneContainerSessionArray): void {
  }

  // ----------------------------------------------------------------------------------------------------
  // SceneSession List Management
  // ----------------------------------------------------------------------------------------------------

  /**
   * inner register container session list.
   * @param usage the list usage for what
   * @param sessionList SCBSceneContainerSessionArray
   */
  protected registerContainerSessionList(usage: string, sessionList: SCBSceneContainerSessionArray): void {
    if (!usage || usage.length === 0 || !sessionList) {
      log.showError('invalid container session list to add');
      return;
    }
    if (this.containerSessionMap.has(usage)) {
      log.showWarn('duplicate usage list added, will replace older');
    }
    this.containerSessionMap.set(usage, sessionList);
  }

  /**
   * support to get container session list to use.
   * @param usage usage of container session list.
   * @returns SCBSceneContainerSessionArray
   */
  public getContainerSessionList(usage: string = DEFAULT_TOTAL_LIST_TAG): SCBSceneContainerSessionArray {
    if (!usage || usage.length === 0 || !this.containerSessionMap.has(usage)) {
      log.showError('invalid usage to get container session list.');
      return new SCBSceneContainerSessionArray();
    }
    return this.containerSessionMap.get(usage);
  }

  /**
   * find container session by info
   * @param sceneInfo info of target session to find
   * @param usage find session by info from which usage list, if empty will find in all.
   * @returns container session or null
   */
  public getContainerSessionBySceneInfo(sceneInfo: SCBSceneInfo,
    usage: string = ''): SCBSceneContainerSession | null {
    if (!sceneInfo) {
      log.showError(`${this.logTag} invalid sceneInfo`);
      return null;
    }
    if (usage && usage.length !== 0) {
      const containerSession = this.containerSessionMap.get(usage)?.findItemBySceneInfo(sceneInfo);
      if (containerSession) {
        log.showInfo(`${this.logTag}get existing session from usage-${usage} list.`);
        return containerSession;
      }
    }
    for (let item of this.containerSessionMap.entries()) {
      const containerSession = item?.[1].findItemBySceneInfo(sceneInfo);
      if (containerSession) {
        log.showInfo(`${this.logTag} get existing session from usage-${item[0]} list.`);
        return containerSession;
      }
    }
    log.showInfo(`${this.logTag} get none existing session.`);
    return null;
  }

  /**
   * find container session by persistentId
   * @param persistentId persistentId of target session to find
   * @param usage find session from which usage list, if empty will find in all.
   * @returns container session or null
   */
  public getContainerSessionByPersistentId(persistentId: number,
    usage: string = ''): SCBSceneContainerSession | null {
    if (!persistentId || persistentId <= INVALID_PERSISTENT_ID){
      log.showError(`${this.logTag} invalid persistentId`);
      return null;
    }
    if (usage && usage.length !== 0) {
      const containerSession = this.containerSessionMap.get(usage)?.findItemByPersistentId(persistentId);
      if (containerSession) {
        log.showInfo(`${this.logTag}get existing session from usage-${usage} list.`);
        return containerSession;
      }
    }
    for (let item of this.containerSessionMap.entries()) {
      const containerSession = item?.[1].findItemByPersistentId(persistentId);
      if (containerSession) {
        log.showInfo(`${this.logTag} get existing session from usage-${item[0]} list.`);
        return containerSession;
      }
    }
    log.showInfo(`${this.logTag} get none existing session.`);
    return null;
  }

  /**
   * get MainSessionTuple from current panel.
   * @param info SCBSceneInfo
   * @param usage from which list, default empty usage is find in all.
   * @returns SCBMainSessionTuple
   */
  public getMainSessionTupleByInfo(info: SCBSceneInfo, usage: string = ''): SCBMainSessionTuple {
    // try match by id
    let containerSession = this.getContainerSessionByPersistentId(info?.persistentId, usage);
    if (containerSession) {
      return { sceneSession: containerSession.getSceneSessionById(info?.persistentId), containerSession: containerSession };
    }
    // try match by bundle info
    containerSession = this.getContainerSessionBySceneInfo(info, usage);
    if (containerSession) {
      return { sceneSession: containerSession.getSceneSessionByInfo(info), containerSession: containerSession };
    }
    return { sceneSession: null, containerSession: null };
  }

  /**
   * get MainSessionTuple from current panel
   * @returns SCBMainSessionTuple
   */
  public getMainSessionTupleById(persistentId: number, usage: string = ''): SCBMainSessionTuple {
    const containerSession = this.getContainerSessionByPersistentIdOrContainerId(persistentId, undefined, usage);
    if (containerSession) {
      return { sceneSession: containerSession.getSceneSessionById(persistentId), containerSession: containerSession };
    }
    return { sceneSession: null, containerSession: null };
  }

  /**
   * 获取当前最顶层的活动窗口容器会话
   * @description default find in total list.
   * @returns 当前最顶层的活动窗口容器会话，如果未找到则返回null
   */
  public getTopActiveSession(usage: string = DEFAULT_TOTAL_LIST_TAG): SCBSceneContainerSession | null {
    return this.getContainerSessionList(usage).getTopActiveSession();
  }

  /**
   * 添加窗口容器会话到窗口容器集合中
   *
   * @param sceneContainerSession 窗口容器会话
   * @param usage 默认是添加到total list
   */
  public addSceneContainerSession(sceneContainerSession: SCBSceneContainerSession,
    usage: string = DEFAULT_TOTAL_LIST_TAG): void {
    if (!sceneContainerSession) {
      log.showError('ignore add a null container session.');
      return;
    }
    log.showInfo(`add container session: ${sceneContainerSession?.getName()}`);
    this.getContainerSessionList(usage).add(sceneContainerSession);
  }

  /**
   * 将目标窗口容器会话从窗口容器集合中移除
   *
   * @param sceneContainerSession 窗口容器会话
   * @param 当usage为空，从所有list中删除
   */
  public removeSceneContainerSession(sceneContainerSession: SCBSceneContainerSession, usage?: string): void {
    if (!sceneContainerSession) {
      log.showError('ignore remove a null container session.');
      return;
    }
    if (this.containerSessionMap.has(usage)) {
      log.showInfo(`remove container session: ${sceneContainerSession.getName()} in usage-${usage} list`);
      this.getContainerSessionList(usage).deleteByContainerId(sceneContainerSession.containerId);
    } else {
      log.showInfo(`remove container session in map.`);
      for (let sessionList of this.containerSessionMap.values()) {
        sessionList.deleteByContainerId(sceneContainerSession.containerId);
      }
    }
  }

  /**
   * 根据窗口id或窗口容器id查找对应窗口容器会话
   *
   * @param persistentId 窗口id
   * @param containerId 窗口容器id
   * @param usage list tag. 使用方法：从固定List中移除，空值或者空字符串情况下会全局查找
   * @return
   *   - SCBSceneContainerSession: 查找到对应的窗口容器会话
   *   - null： 未查找到返回
   */
  public getContainerSessionByPersistentIdOrContainerId(persistentId?: number,
    containerId?: number, usage?: string): SCBSceneContainerSession | null {
    if (!usage || usage.length === 0) {
      for (let sessionList of this.containerSessionMap.values()) {
        const session = sessionList.findByPersistentId(persistentId) ?? sessionList.findByContainerId(containerId);
        if (session) {
          return session;
        }
      }
      return null;
    }
    if (persistentId) {
      return this.getContainerSessionList(usage).findByPersistentId(persistentId);
    } else if (containerId) {
      return this.getContainerSessionList(usage).findByContainerId(containerId);
    }
    return null;
  }

  /**
   * 将目标窗口移动到链表末尾，通常意味着移动窗口到屏幕最上层
   *
   * @param sceneContainerSession 窗口容器会话
   * @param usage list tag，在指定的List中移动到链表末尾
   */
  public raiseSceneToTopInList(sceneContainerSession: SCBSceneContainerSession, usage: string): void {
    if (!sceneContainerSession) {
      log.showError('ignore raise a null container session to top');
      return;
    }
    if (!this.containerSessionMap.has(usage)) {
      log.showError(`ignore raise top in invalid usage-${usage} list`);
      return;
    }
    log.showInfo(`raiseSceneToTopInList: ${sceneContainerSession.getName()}`);
    const sessionList = this.getContainerSessionList(usage);
    // To move the sceneContainerSession to the last of list.
    sessionList.deleteByContainerId(sceneContainerSession.containerId);
    sessionList.add(sceneContainerSession);
  }
}