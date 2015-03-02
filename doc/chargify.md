Chargify integration
===========================

MailChimp integration
---------------------

This needs to be set up in Chargify. You choose a `list` that subscribers will
be synced to.  You can’t remove or add other members to this list as it will be
kept in sync with the subscriptions in Chargify.

So mail outs may want to use a combination of lists or subsets based on product.

Product setup
-------------

For each pricing plan available for supporters there needs to be a product
setup in Chargify that maps to it by setting the `API Handle`.

Currently the system expects there to be products for

  1. `individual_supporter`
  2. `supporter_annual`
  3. `corporate_supporter_annual`

You can then set up the `Recurring Period and Price` for each of these
products. `Initial/Setup Fee` can be left blank as Chargify starts billing
immediately for the recurring payment.

Everytime you create a product you need to make sure there is a `Public Signup
Page` set up for the product with the `Return url` and `Return parameters` set
to these values:

### Return url

    https://directory.theodi.org/members/chargify_return

### Return parameters

    reference={customer_reference}&customer_id={customer_id}&subscription_id={subscription_id}&payment_id={signup_payment_id}

Webhook setup
-------------

A webhook for `signup success` needs to be set up to verify that payments are
recorded correctly using this url:

    https://directory.theodi.org/members/chargify_verify

Discounts
---------

Coupon codes can be set up in Chargify too, the coupon code you choose needs to
be appened to the new member url so instead of the usual:

    https://directory.theodi.org/members/new?level=individual

or

    https://directory.theodi.org/members/new?level=supporter

You will need to append `&coupon={COUPONCODE}` on the end. eg:

    https://directory.theodi.org/members/new?level=individual&coupon=COUPONCODE

or
    https://directory.theodi.org/members/new?level=supporter&coupon=COUPONCODE

Deployment setup
================

## Environment variables

### `CHARGIFY_API_KEY`

The API key from Chargify, available from the `API Access` menu.

### `CHARGIFY_SUBDOMAIN`

The subdomain name of the `Site` created in Chargify

### `CHARGIFY_SITE_KEY`

Available at the bottom of the edit page for the `Site`
