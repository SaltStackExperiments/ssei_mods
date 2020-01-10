from __future__ import absolute_import, print_function, unicode_literals
import logging

# from pprint import pprint
LOGGER = logging.getLogger(__name__)

NAMECOM_LOADED = False
try:
    from namecom import Auth, DnsApi
    NAMECOM_LOADED = True
except Exception as exc:
    LOGGER.error('pynamecom module not installed')


def __virtual__(**kwargs):
    """Determine whether the namecom module has been loaded

    """
    namecom_user = __salt__.config.get('namecom_user')
    namecom_token = __salt__.config.get('namecom_token')
    profile = __salt__.pillar.get('sse_scripts_deploy_key:myprofile')

    loaded = True
    if not namecom_token and namecom_user:
        LOGGER.error('required config values namecom_user and namecom_token are not set')
        loaded = False

    if not profile:
        LOGGER.error('required aws profile not set in pillar')
        loaded = False

    if not NAMECOM_LOADED:
        LOGGER.error('pynamecom module not installed')
        loaded = False

    return loaded


def record_exists(name, domain, record_type, elb_name):
    """Create a DNS record for the elb at elb_name

    :name: TODO
    :domain: TODO
    :record_type: TODO
    :elb_name: TODO
    :returns: TODO

    """
    ret = {
        'name': name,
        'result': False,
        'changes': {},
        'comment': 'no comment'}

    api = _get_api(domain)
    record = _get_record(name, domain)

    answer = _get_elb_cname(elb_name)

    if record:
        update_record = False
        if record.type != record_type:
            update_record = True
        if record.answer != answer:
            update_record = True

        if update_record:
            if not __opts__['test']:

                updated_record = api.update_record(id=record.id,
                                                   host=name,
                                                   type=record_type,
                                                   answer=answer)
                ret['result'] = True
                ret['changes'] = {'old': record, 'new': updated_record}
            else:
                ret['result'] = 'None'
                ret['comment'] = 'would have updated the record'
    else:
        if not __opts__['test']:
            record = api.create_record(host=name,
                                       type=record_type,
                                       answer=answer)
            ret['result'] = True
            ret['changes'] = {'old': record, 'new': record}
        else:
            ret['result'] = 'None'
            ret['comment'] = 'would have created the record'

    return ret


def _get_record(hostname, domain, page=1):
    """Gett the dns record for <hostname>

    :hostname: TODO
    :returns: TODO

    """
    api = _get_api(domain)
    record_results = api.list_records(page=1)
    for r in record_results.records:
        if r.fqdn[:-1] == hostname:
            return r
    if record_results.nextPage:
        return _get_record(hostname, domain, record_results.nextPage)


def _get_elb_cname(elb_name):

    # make call to boto_elb to get the cname of the elb <elb_name>

    elb_info = __salt__.boto_elb.get_attributes(elb_name,
                                                region=None,
                                                key=None,
                                                keyid=None)

    LOGGER.debug('elb_info %s', elb_info)

    cname = elb_info['CNAME']

    return cname


def _get_api(domain):
    """Get an api object
    :returns: TODO

    """
    namecom_user = __salt__.config.get('namecom_user')
    namecom_token = __salt__.config.get('namecom_token')

    auth = Auth(namecom_user, namecom_token)
    LOGGER.debug('namecom_user: %s', namecom_user)
    LOGGER.debug('namecom_token: %s', namecom_token)
    return DnsApi(domainName=domain, auth=auth)
